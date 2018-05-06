## Exercise 9 - Distributed Tracing

The sample guestbook application shows how a Spring Java application can be configured to collect trace spans using Zipkin or Jaeger.

Although Istio proxies are able to automatically send spans, it needs help from the application to tie together the entire trace. To do this applications need to propagate the appropriate HTTP headers so that when the proxies send span information to Zipkin or Jaeger, the spans can be correlated correctly into a single trace.

To do this the guestbook application collects and propagate the following headers from the incoming request to any outgoing requests:

- `x-request-id`
- `x-b3-traceid`
- `x-b3-spanid`
- `x-b3-parentspanid`
- `x-b3-sampled`
- `x-b3-flags`
- `x-ot-span-context`

This is done with the Spring Istio Support written by Ray Tsang:

https://github.com/retroryan/istio-by-example-java/tree/master/spring-boot-example/spring-istio-support/src/main/java/com/example/istio

#### View Guestbook Traces

Generate a small load to the application either using wrk2 or a shell script:

With shell script:

```sh
while sleep 0.5; do curl http://$INGRESS_IP/echo/universe -A mobile; done
```

Or, with fortio:

```sh
docker run istio/fortio load -t 5m -qps 5 \
  http://$INGRESS_IP/echo/universe
```


### Zipkin
Establish port forward from local port:

```sh
kubectl port-forward -n istio-system \
  $(kubectl get pod -n istio-system -l app=zipkin -o jsonpath='{.items[0].metadata.name}') \
  9411:9411
```

f you are in Cloud Shell, you'll need to use Web Preview and Change   Port to `9411`. Else, browse to http://localhost:9411

#### [Continue to Exercise 10 - Request Routing and Canary Testing](../exercise-10/README.md)
