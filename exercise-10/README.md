## Exercise 10 - Istio Ingress Controller

The components deployed on the service mesh by default are not exposed outside the cluster.  External access to individual services so far has been provided by creating an external load balancer on each service.  

A Kubernetes Ingress rule can be created that routes external requests through the Istio Ingress Controller to the backing services.

#### Configure Guess Book Ingress Routes with the Istio Ingress Controller

1 - Configure the Guess Book UI default route with the Istio Ingress Controller:

```
kubectl apply -f guestbook/guestbook-ingress.yaml
```

In this file notice that the ingress class is specified as   `kubernetes.io/ingress.class: istio` which routes the request to Istio.

The second thing to notice is that the request is routed to different services, either helloworld-service or guestbook-ui depending on the request.  

2 - Find the external IP of the Istio Ingress controller:

```
kubectl get svc -n istio-system

NAMESPACE      NAME                   CLUSTER-IP      EXTERNAL-IP      PORT(S)                                                  AGE
istio-system   istio-ingress          10.31.244.185   35.188.171.180   80:31920/TCP,443:32165/TCP                               1h

```

3 - Browse to the website of the guest Book using the INGRESS IP to see the Guest Book UI.  

http://INGRESS_IP/hello/world

Also you should be able to curl the Guest Book using:

```
curl http://INGRESS_IP/echo/universe  
```

And the hello world service with:

```
http://INGRESS_IP/hello/world
```

#### [Continue to Exercise 11 - Request Routing and Canary Deployments](../exercise-11/README.md)
