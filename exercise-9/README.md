## Exercise 9 - Fault Injection and Rate Limiting

#### Overview of Istio Mixer

https://istio.io/docs/concepts/policy-and-control/mixer.html

#### Setting Up Mixer for Kubernetes

First we configure Mixer for a kubernetes environment, setting up the kubernetes adapter to produce attributes about the kubernetes deployment (e.g. the labels on the target and source pods).

```
    istioctl mixer rule create global global -f mixer-kubernetes.yaml
```

#### Service Isolation Using Mixer

Block Access to the hello world service by adding the mixer-rule-denial.yaml rule shown below:

```
  rules:
    - selector: source.labels["app"]=="helloworld-ui"
      aspects:
      - kind: denials
```

```
    istioctl mixer rule create global helloworld-service.default.svc.cluster.local -f mixer-rule-denial.yaml
```

#### Block Access to v2 of the hello world service

```
    rules:
      - selector: destination.labels["app"]=="helloworld-ui" && source.labels["version"] == "v2"
        aspects:
        - kind: denials
```

```
  istioctl mixer rule create global helloworld-service.default.svc.cluster.local -f mixer-rule-denial-v2.yaml
```

Then we clean up the rules to get everything working again:

```
  istioctl mixer rule delete global helloworld-service.default.svc.cluster.local
```

#### [Continue to Exercise 10 - Telemetry and Rate Limiting with Mixer](../exercise-10/README.md)
