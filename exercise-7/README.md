## Request Routing with Istio Route Rules

#### Create the necessary cluster roles

`kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole=cluster-admin \
    --user=$(gcloud config get-value core/account)`

#### Deploy Istio Pilot

Details about the Istio Pilot can be found in the section about the [Istio Pilot in the Istio Docs](https://istio.io/docs/concepts/what-is-istio/overview.html#pilot)

`kubectl apply -f istio-pilot.yaml`

#### Deploy Istio Proxy

Details about the Istio Proxy can be found in the section about the [Envoy Proxy in the Istio Docs](https://istio.io/docs/concepts/what-is-istio/overview.html#envoy)

To create the Istio Ingress Proxy we will apply the istio-ingress.yaml.  Similar to the pilot it also creates roles, a service account, deployment and kubernetes service.

`kubectl apply -f istio-ingress.yaml`

#### Verify the Pilot and Proxy are deployed

The list of pods should show istio-pilot and istio-proxy running:

`kubectl get pods`

#### Kubernetes Ingress Resources

The Istio Ingress Proxy is deployed as a Kubernetes Ingress Controller.  That means that Kubernetes Ingress rules can be used to configure the Ingress traffic to route to the Kubernetes Services.  This is done by deploying an Kubernetes Ingress Resource that directs traffic to the different services.

`kubectl create -f ingress-helloworld.yaml`

`curl 104.155.181.0/hello/world`
