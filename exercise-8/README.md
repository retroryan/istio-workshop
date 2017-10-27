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

#### Canary Deployments

Currently the routing rule routes only to V1 of the hello world service which is not real useful. What we want to do next is a canary deployment and push some of the traffic to V2. This can be done by creating another rule with a higher precedence that routes some of the traffic to V2 based on http headers.  As an example we will use the following canary deployment in canary-helloworld.yaml

```
  type: route-rule
  name: canary-helloworld-v2
  namespace: default
  spec:
    destination: helloworld-service.default.svc.cluster.local
    match:
      httpHeaders:
        foo:
          exact: mobile
    precedence: 2
    route:
      - tags:
          version: v1
```

Note that rules with a higher precedence number are applied first.  If a precedence is not specified then it defaults to 0.  So with these 2 rules in place the one with precedence 2 will be applied first.

Test this out by creating the rule:

```
    istioctl create -f guestbook/canary-helloworld.yaml
```

Now when you curl the end point set the user agent to be mobile and you should only see V2:

```
$ curl http://104.198.198.111/echo/universe -A mobile

{"greeting":{"hostname":"helloworld-service-v2-3297856697-6m4bp","greeting":"Hello dog2 from helloworld-service-v2-3297856697-6m4bp with 2.0","version":"2.0"}

$ curl 35.188.171.180/echo/universe

{"greeting":{"hostname":"helloworld-service-v1-286408581-9204h","greeting":"Hello universe from helloworld-service-v1-286408581-9204h with 1.0","version":"1.0"},"

```

An important point to note is that the user-agent http header is propagated in the span baggage.  Look at these two classes for details:

https://github.com/retroryan/istio-by-example-java/blob/master/spring-boot-example/spring-istio-support/src/main/java/com/example/istio/IstioHttpSpanInjector.java

https://github.com/retroryan/istio-by-example-java/blob/master/spring-boot-example/spring-istio-support/src/main/java/com/example/istio/IstioHttpSpanExtractor.java


#### [Continue to Exercise 9 - Fault Injection](../exercise-9/README.md)
