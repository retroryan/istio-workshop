## Exercise 11 - Fault Injection and Circuit Breaking

In this exercise we will learn how to test the resiliency of an application by injecting faults.

To test our guestbook application for resiliency, this exercise will test injecting different levels of delay when the user agent accessing the hello world service is mobile.

#### Inject a route rule to delay request

We can inject delays into the request.

```sh
kubectl apply -f istio/guestbook-ui-delay-vs.yaml
```

Browse to the Guestbook UI, and you'll see that the request is responding much slower!

#### Inject error responses

We can also inject error responses, such as returning 503 from a service.

```sh
kubectl apply -f istio/guestbook-service-503-vs.yaml
```

Visiting the Guestbook UI, and you'll see that it is now unable to retrieve any Guestbook messages. Luckily, the application has a graceful fallback to display a nice error message.

#### Remove the faults

Remove the annoying 503 errors.

```sh
kubectl delete -f istio/guestbook-service-503-vs.yaml
```

Then reset the Guestbook UI virtual service so that it routes all requests to V1.

```sh
kubectl apply -f istio/guestbook-ui-v1-vs.yaml
```

#### Circuit Breaking

There are several circuit breaker rules you can apply in Istio:
* Retries
* Outlier Detection
* Connection pooling

Retries can be configured in the virtual service.

```sh
kubectl apply -f istio/guestbook-service-retry-vs.yaml
```

Outlier and connection pooling are configured in the destination rule.

```sh
kubectl apply -f istio/guestbook-service-dest.yaml
```

```sh
kubectl apply -f istio/guestbook-service-dest.yaml
```

#### [Continue to Exercise 12 - Service Isolation Using Mixer](../exercise-12/README.md)
