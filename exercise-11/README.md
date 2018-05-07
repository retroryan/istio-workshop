## Exercise 11 - Service Isolation Using Mixer

#### First clean up old route rules:


```yaml
  istioctl delete -f guestbook/route-rule-80-20.yaml
  istioctl delete -f guestbook/route-rule-user-mobile.yaml
```

#### Service Isolation Using Mixer

We'll block access to the Hello World service by adding the mixer-rule-denial.yaml rule shown below:

```yaml
# Create a denier that returns a google.rpc.Code 7 (PERMISSION_DENIED)
apiVersion: "config.istio.io/v1alpha2"
kind: denier
metadata:
  name: denyall
  namespace: istio-system
spec:
  status:
    code: 7
    message: Not allowed
---
# The (empty) data handed to denyall at run time
apiVersion: "config.istio.io/v1alpha2"
kind: checknothing
metadata:
  name: denyrequest
  namespace: istio-system
spec:
---
# The rule that uses denier to deny requests to the helloworld service
apiVersion: "config.istio.io/v1alpha2"
kind: rule
metadata:
  name: deny-hello-world
  namespace: istio-system
spec:
  match: destination.service=="helloworld-service.default.svc.cluster.local"
  actions:
  - handler: denyall.denier
    instances:
    - denyrequest.checknothing
```

```sh
istioctl create -f guestbook/mixer-rule-denial.yaml
```

Verify that access is now denied:

```sh
curl http://$INGRESS_IP/hello/world
```

#### Block Access to v2 of the Hello World service

```yaml
# The rule that uses denier to deny requests to version 2.0 of the helloworld service
apiVersion: "config.istio.io/v1alpha2"
kind: rule
metadata:
  name: deny-hello-world
  namespace: istio-system
spec:
  match: destination.service=="helloworld-service.default.svc.cluster.local" && destination.labels["version"] == "2.0"
  actions:
  - handler: denyall.denier
    instances:
    - denyrequest.checknothing
```

```sh
istioctl delete -f guestbook/mixer-rule-denial.yaml
istioctl create -f guestbook/mixer-rule-denial-v2.yaml
```

Check that you can access the v1 service:
```sh
curl http://$INGRESS_IP/hello/world
```

But you should not be able to access v2:
```sh
curl http://$INGRESS_IP/hello/world -A mobile
```

Clean up the rule:

```sh
istioctl delete -f guestbook/mixer-rule-denial-v2.yaml
```

#### [Continue to Exercise 12 - Fault Injection and Rate Limiting](../exercise-12/README.md)
