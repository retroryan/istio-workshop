## Exercise 10 - Request Routing and Canary Testing

#### Deploy Guestbook UI 2.0

We currently have Guestbook UI 1.0 running in the environment. Let's deploy Guestbook UI 2.0, which has a green background.

```sh
kubectl apply -f kubernetes-v2/guestbook-ui-deployment-v2.yaml
```

Once deployed, browse to the Ingress IP from the previous exercise and you should see that everytime you reload the Guestbook UI website, it'll switch between the 2 versions (2 different background colors).

#### Default the to V1

We can default the production traffic to V1.

1 - Define Destination Rule

Istio needs your help to understand which deployments/pods belongs to which version. We can use `DestinationRule` to define `subsets`. A `subset` is a way group different pods together into a `subset` by using Kubernetes label selectors.

```sh
kubectl apply -f istio/guestbook-ui-dest.yaml
```

2 - Define Virtual Service

Earlier in the lab we used virtual service to bind Kubernetes service to Istio Ingress Gateway. A virtual service can also be used to define routing rules and traffic shifting rules as well. Let's configure the virtual service so that all the requests go to `v1`.

```sh
kubectl apply -f istio/guestbook-ui-v1-vs.yaml
```

If you refresh Guestbook UI several times, you should see that all of the requests are now responded by V1 application.

#### Traffic Shifting

Rather than routing 100% of the traffic to `v1`, you can also configure weights so that you can route `x%` of traffic to `v1`, and `y%` of traffic to `v2`, etc.

```sh
kubectl apply -f istio/guestbook-ui-80p-v1-vs.yaml
```

If you refresh Guestbook UI several times, you should see that most of the requests are now responded by V1 application, and some requests are responded by V2 application. You can adjust the weights and reapply the file to test different probabilities.

#### Route based on HTTP header

We can also canary test based on HTTP headers. For example, if we want to test different versions of the application based on browser's User Agent, we can setup match rules against the header values.

```sh
kubectly apply -f istio/guestbook-ui-chrome-vs.yaml
```

Try browsing the Guestbook UI with both Chrome and Firefox. Chrome should show V2 of the application, and Firefox should show V1 of the application.

#### [Continue to Exercise 11 - Fault Injection and Rate Limiting](../exercise-11/README.md)
