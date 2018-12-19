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

Our sample application uses Spring Boot 2 and Spring Cloud Finchley release. Spring Cloud has built in Zipkin header propagation using Spring Cloud Sleuth, which will automatically propagate `x-b3-*` headers.

To configure additional headers to propagate, the sample application configured `application.properties` to add additional `propagation keys`, e.g., `spring.sleuth.propagation-keys=x-request-id,x-ot-span-context`.

#### View Guestbook Traces

Browse to the Guestbook UI and say Hello a few times.

### Jaeger

Istio demo configuration installs Jaeger for trace collection. This is interchangeable. Setup a port-forward in the usual way.

```sh
kubectl -n istio-system port-forward $(kubectl -n istio-system get po -l app=jaeger -o jsonpath='{.items[0].metadata.name}') 16686
```

Browse to http://localhost:16886. 

Under *Find Traces* and in *Service* drop down, select *guestbook-ui*, and then click on *Find Traces*.

#### [Continue to Exercise 10 - Request Routing and Canary Testing](../exercise-10/README.md)
