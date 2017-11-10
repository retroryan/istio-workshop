## Exercise 8 - Request Routing and Canary Deployments

Because there are 2 version of the HelloWorld Service Deployment (v1 and v2), before modifying any of the routes a default route needs to be set to just V1. Otherwise it will just round robin between V1 and V2

#### Configure the default route for hello world service

1 - Set the default version for all requests to the hello world service using :

```
istioctl create -f guestbook/route-rule-force-hello-v1.yaml
```

This ingress rule forces `v1` of the service by giving it a weight of 100. We can see this by describing the resource we created:
```sh
kubectl describe routerules helloworld-default

Name:         helloworld-default
Namespace:    default
Labels:       <none>
Annotations:  <none>
API Version:  config.istio.io/v1alpha2
Kind:         RouteRule
Metadata:
  ...
Spec:
  Destination:
    Name:      helloworld-service
  Precedence:  1
  Route:
    Labels:
      Version:  1.0
```

2 - Now when you curl the echo service it should always return V1 of the hello world service:

```sh
curl http://$INGRESS_IP/echo/universe  

{"greeting":{"hostname":"helloworld-service-v1-286408581-9204h","greeting":"Hello universe from helloworld-service-v1-286408581-9204h with 1.0","version":"1.0"},"
```
```sh
curl 35.188.171.180/echo/universe

{"greeting":{"hostname":"helloworld-service-v1-286408581-9204h","greeting":"Hello universe from helloworld-service-v1-286408581-9204h with 1.0","version":"1.0"},"
```

#### Canary Deployments

Currently the routing rule only routes to `v1` of the hello world service which. What we want to do is canary a deployment of `v2` of the hello world service by allowing only a small amount of traffic to it. This can be done by creating another rule with a higher precedence that routes some of the traffic to `v2`. We'll canary based on HTTP headers: if the user-agent is "mobile" it'll go to `v2`, otherwise requests will go to `v1`. Written as a route rule, this looks like:

```yaml
destination:
  name: helloworld-service
match:
  request:
    headers:
      user-agent:
        exact: mobile
precedence: 2
route:
  - labels:
      version: "2.0"
```

Note that rules with a higher precedence number are applied first. If a precedence is not specified then it defaults to 0. So with these two rules in place the one with precedence 2 will be applied before the rule with precedence 1.

Test this out by creating the rule:
```sh
istioctl create -f guestbook/route-rule-canary.yaml
```

Now when you curl the end point set the user agent to be mobile and you should only see V2:

```sh
curl http://$INGRESS_IP/echo/universe -A mobile

{"greeting":{"hostname":"helloworld-service-v2-3297856697-6m4bp","greeting":"Hello dog2 from helloworld-service-v2-3297856697-6m4bp with 2.0","version":"2.0"}
```
```sh
$ curl $INGRESS_IP/echo/universe

{"greeting":{"hostname":"helloworld-service-v1-286408581-9204h","greeting":"Hello universe from helloworld-service-v1-286408581-9204h with 1.0","version":"1.0"},"
```

An important point to note is that the user-agent http header is propagated in the span baggage. Look at these two classes for details on how the header is [injected](https://github.com/retroryan/istio-by-example-java/blob/master/spring-boot-example/spring-istio-support/src/main/java/com/example/istio/IstioHttpSpanInjector.java) and [extracted](https://github.com/retroryan/istio-by-example-java/blob/master/spring-boot-example/spring-istio-support/src/main/java/com/example/istio/IstioHttpSpanExtractor.java):

#### Optional - Route based on the browser

It is also possible to route it based on the Web Browser. For example the following routes to version 2.0 if the browser is chrome:

```yaml
match:
  request:
    headers:
      user-agent:
        regex: ".*Chrome.*"
route:
- labels:
    version: "2.0"
```

To apply this route run:

```sh
istioctl create -f guestbook/route-rule-user-agent-chrome.yaml
```

Then navigate to the home page in Chrome and another browser.

#### [Continue to Exercise 9 - Fault Injection](../exercise-9/README.md)
