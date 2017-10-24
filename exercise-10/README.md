## Exercise 10 - Request Routing and Canary Deployments

Because there are 2 version of the HelloWorld Service Deployment (v1 and v2), before modifying any of the routes a default route needs to be set to just c1.

#### Configure Guess Book Default Route with the Istio Ingress Controller

1 - Configure the Guess Book UI default route with the Istio Ingress Controller:

```
kubectl apply -f guestbook-ui-ingress.yaml
```

This ingress rule force v1 of the service by giving it a weight of 100.

2 - Then find the external IP of the Istio Ingress controller:

```
kubectl get svc -n istio-system
NAMESPACE      NAME                   CLUSTER-IP      EXTERNAL-IP      PORT(S)                                                  AGE
istio-system   istio-ingress          10.31.244.185   35.188.171.180   80:31920/TCP,443:32165/TCP                               1h


```

3 - Browse to the website of the guest Book

Then you should be able to browse to the IP address to see the Guest Book UI.  

http://INGRESS_IP/hello/world

Also you should be able to curl the Guest Book UI using:

```
curl http://INGRESS_IP/echo/universe  
```

And the hello world service with:

```
http://INGRESS_IP/hello/world
```

#### [Continue to Exercise 11 - Fault Injection](../exercise-11/README.md)
