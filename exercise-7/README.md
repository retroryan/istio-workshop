## Exercise 7 - Istio Ingress Controller

The components deployed on the service mesh by default are not exposed outside the cluster. External access to individual services so far has been provided by creating an external load balancer on each service.

A Kubernetes Ingress rule can be created that routes external requests through the Istio Ingress Controller to the backing services.

#### Configure Guess Book Ingress Routes with the Istio Ingress Controller

1 - Configure the Guess Book UI default route with the Istio Ingress Controller:

```sh
kubectl apply -f guestbook/guestbook-ingress.yaml
```

In this file notice that the ingress class is specified as   `kubernetes.io/ingress.class: istio` which routes the request to Istio.

The second thing to notice is that the request is routed to different services, either helloworld-service or guestbook-ui depending on the request. We can see how this works by having Kubernetes describe the ingress resource for us:

```sh
kubectl describe ingress

Name:             simple-ingress
Namespace:        default
Address:          
Default backend:  default-http-backend:80 (<none>)
Rules:
  Host  Path  Backends
  ----  ----  --------
  *     
        /hello/.*   helloworld-service:8080 (<none>)
        /.*         guestbook-ui:80 (<none>)
Annotations:
Events:  <none>

```

2 - Find the external IP of the Istio Ingress controller:

```sh
kubectl get service istio-ingress -n istio-system

NAMESPACE      NAME                   CLUSTER-IP      EXTERNAL-IP      PORT(S)                                                  AGE
istio-system   istio-ingress          10.31.244.185   35.188.171.180   80:31920/TCP,443:32165/TCP                               1h
```

```sh
export INGRESS_IP=<External IP from above>
```

3 - Browse to the website of the guest Book using the INGRESS IP to see the Guest Book UI: `http://INGRESS_IP`

4 - You can also access the hello world service and see the json in the browser:
`http://INGRESS_IP/hello/world`


5 - curl the Guest Book:
```
curl http://$INGRESS_IP/echo/universe
```

And the hello world service:
```
curl http://$INGRESS_IP/hello/world
```

6 - Then curl the echo endpoint multiple times and notice how it round robins between v1 and v2 of the hello world service:

```sh
curl http://$INGRESS_IP/echo/universe

{"greeting":{"hostname":"helloworld-service-v1-286408581-9204h","greeting":"Hello universe from helloworld-service-v1-286408581-9204h with 1.0","version":"1.0"},
```

```sh
curl http://$INGRESS_IP/echo/universe

{"greeting":{"hostname":"helloworld-service-v2-1009285752-n2tpb","greeting":"Hello universe from helloworld-service-v2-1009285752-n2tpb with 2.0","version":"2.0"}

```

#### [Exercise 8 - Telemetry](../exercise-8/README.md)
