## Exercise 12 - Fault Injection and Rate Limiting

In this exercise we will learn how to test the resiliency of an application by injecting faults.

To test our guestbook application for resiliency, this exercise will test injecting different levels of delay when the user agent accessing the hello world service is mobile.


#### Inject a route rule to delay hello world


We'll delay access to the Hello World service by adding the mixer-rule-denial.yaml rule that forces a delay:

```yaml
httpFault:
  delay:
    percent: 100
    fixedDelay: 10s
  abort:
      percent: 10
      httpStatus: 400
```

Be sure the old route rule for mobile is removed before adding the delay.

```sh

istioctl delete -f guestbook/route-rule-user-mobile.yaml

istioctl create -f guestbook/route-rule-delay-guestbook.yaml
```

When you curl without a user agent it should return a response as expected:

```sh
curl http://$INGRESS_IP/echo/universe
```

However when you curl with the user agent mobile the connection will timeout:

```sh
$ curl http://$INGRESS_IP/echo/universe -A mobile
{"greeting":{"greeting":"Unable to connect"},
```

If you modify the delay below the timeout configured in the applciation the service will still return.  For example if we modify it to 4 seconds, the guestbook service still returns a response.


#### [Continue to Exercise 13 - Security](../exercise-13/README.md)
