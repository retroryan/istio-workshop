## Istio RBAC

#### Mixer all the way down

Istio has an RBAC engine implemented as a mixer adapter. There are a number of things that need to be configured before it can be turned loose on unsuspecting services.

#### Who did what

The foundation is an instance of an authorization template. The purpose of the auth template is to select from the attribute vocabulary available a subset that will be endowed with specific meaning for RBAC. Consider subject selection; who is making the request? This could be extracted from a header, from the SPIFFE URI, from a cookie etc etc. The authorization template is what specifies this.

Example usage:

```
apiVersion: "config.istio.io/v1alpha2"
kind: authorization
metadata:
  name: requestcontext
  namespace: istio-system
spec:
  subject:
    user: source.user | ""
    groups: ""
    properties:
      app: source.labels["app"] | ""
      version: source.labels["version"] | ""
      namespace: source.namespace | ""
  action:
    namespace: destination.namespace | ""
    service: destination.service | ""
    method: request.method | ""
    path: request.path | ""
    properties:
      app: destination.labels["app"] | ""
      version: destination.labels["version"] | ""
```

Subject is the who, action is the what. In this instance will we be using the _service account_ as the user, which will allow us to take advantage of SPIFFE identity asserted by our x509 certificates. We also take advantage of properies to include metadata in our auth decisions, for instance the app label.

#### The binding of services

In order to make decisions about what we will allow we need two more ingredients: roles, and bindings of those roles to eligible inbound requests. An example role:

```
Version: "config.istio.io/v1alpha2"
kind: ServiceRole
metadata:
  name: details-reviews-viewer
  namespace: default
spec:
  rules:
  - services: ["details.default.svc.cluster.local"]
    methods: ["GET"]
  - services: ["reviews.default.svc.cluster.local"]
    methods: ["GET"]
    constraints:
    - key: "version"
      values: ["v2", "v3"]
```

Details to note:
- The role has an applicable namespace
- We define an array of rules, with values to be matched onto the corresponding attributes from our earlier authorization template instance (service / method / path). If path is not supplied it defaults to allowing all paths.
- Finally constraints can be added via the extra properties defined in the authorization template.

What does a binding look like?

```
apiVersion: "config.istio.io/v1alpha2"
kind: ServiceRoleBinding
metadata:
  name: bind-details-reviews
  namespace: default
spec:
  subjects:
  - user: "cluster.local/ns/default/sa/bookinfo-productpage"
  roleRef:
    kind: ServiceRole
    name: "details-reviews-viewer
```

This is relatively straight-forward: We define an array of subjects we would like this binding to apply to and reference the role that we would like to bind to.

In summary: roles are about actions, and role-bindings are about subjects.

#### The final component

We some final config for enablement. This is a mixer adaptor so we need the usual mixer suspects: instances and handlers. 

```
apiVersion: "config.istio.io/v1alpha2"
kind: rbac
metadata:
 name: handler
 namespace: istio-system
spec:
 config_store_url: "k8s://"
---
apiVersion: "config.istio.io/v1alpha2"
kind: rule
metadata:
  name: rbaccheck
  namespace: istio-system
spec:
  actions:
  - handler: handler.rbac
    instances:
    - requestcontext.authorization
```

#### Switching it on

Assume all other shell is run with the working directory set to the Istio release root.

```
cd ~/istio
kubectl create -f samples/bookinfo/platform/kube/bookinfo-add-serviceaccount.yaml
kubectl create -f samples/bookinfo/platform/kube/istio-rbac-enable.yaml
```

Now we should get denied for all the things:

```
kubectl create -f samples/bookinfo/networking/bookinfo-gateway.yaml
INGRESS_IP=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
curl http://$INGRESS_IP/productpage
```

We can let ourselves back in with some roles / bindings.

```
kubectl apply -f samples/bookinfo/kube/istio-rbac-namespace.yaml
```

This creates a catch-all rule that allows service in either `istio-system` or `default` to use `GET` on any service. Open the file for the details. Use curl or a brower to hit the previous endpoint and enjoy unfettered access.

#### Ascending to a higher plane

Let's delete our overly lax policy:

```
kubectl delete -f samples/bookinfo/kube/istio-rbac-namespace.yaml
```

Let's introduce something a bit more fine-grained. A picture of the architecture will be helpful here.

![architecture](https://istio.io/docs/guides/img/bookinfo/withistio.svg)

We'd like ingress to be able to contact the productpage.

```
kubectl apply -f samples/bookinfo/kube/istio-rbac-productpage.yaml
```

Now if we visit the page in the browser we can that we have the first level of the service graph opened up. Again, details are in the file. Currently everything else is showing an error. This is solved by throwing more targeted policy at the problem:

```
kubectl apply -f samples/bookinfo/kube/istio-rbac-details-reviews.yaml
```

This enables reviews (for v2 / v3) and details. Visit the page! You can see how this was done by checking out the file. Note the usage of the spiffe identity.

Lastly:

```
kubectl apply -f samples/bookinfo/kube/istio-rbac-ratings.yaml
```

Ratings should now appear.

That's a wrap!
