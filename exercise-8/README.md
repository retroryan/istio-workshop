## Exercise 8 - Request Routing and Canary Deployments

Because there are 2 version of the HelloWorld Service Deployment (v1 and v2), before modifying any of the routes a default route needs to be set to just V1.  Otherwise it will just round robin between V1 and V2

#### Configure the default route for hello world service

1 - Set the default version for all requests to the hello world service using :

```
istioctl create -f guestbook/force-hello-v1.yaml
```

This ingress rule forces v1 of the service by giving it a weight of 100.

2 - Now when you curl the echo service it should always return V1 of the hello world service:

```
$ curl 35.188.171.180/echo/universe  

{"greeting":{"hostname":"helloworld-service-v1-286408581-9204h","greeting":"Hello universe from helloworld-service-v1-286408581-9204h with 1.0","version":"1.0"},"

$ curl 35.188.171.180/echo/universe

{"greeting":{"hostname":"helloworld-service-v1-286408581-9204h","greeting":"Hello universe from helloworld-service-v1-286408581-9204h with 1.0","version":"1.0"},"


```

#### [Continue to Exercise 9 - Fault Injection](../exercise-9/README.md)
