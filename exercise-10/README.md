## Exercise 10 - Request Routing and Canary Deployments

#### Configure Guess Book Default Route with the Istio Ingress Controller

Because there are 2 version of the HelloWorld Service we need to set a default route.

1 - Configure the Guess Book default route with the Istio Ingress Controller:

```
kubectl apply -f ui-ingress.yaml
```

This ingress rule force v1 of the service by giving it a weight of 100.

2 - Then find the external IP of the istio ingress controller:

```
kubectl get svc -n istio-system
```

3 - Browse to the website of the guest Book

Then you should be able to browse to the IP address to see the hello world UI.  

http://INGRESS_IP/hello/world

Also you should be able to curl the hello world ui using:

```
curl http://INGRESS_IP/echo/universe  
```

And hello world service with:

```
http://INGRESS_IP/hello/world
```

#### [Continue to Exercise 11 - Fault Injection](../exercise-11/README.md)
