## Exercise 10 - Fault Injection and Rate Limiting

#### Overview of Istio Mixer

See the overview of Mixer at [istio.io](https://istio.io/docs/concepts/policy-and-control/mixer.html).

#### Service Isolation Using Mixer

We'll block access to the Hello World service by adding the mixer-rule-denial.yaml rule shown below:

```yaml
# Create a denier that returns a google.rpc.Code 7 (PERMISSION_DENIED)
apiVersion: "config.istio.io/v1alpha2"
kind: denier
metadata:
  name: denyall
  namespace: istio-system
spec:
  status:
    code: 7
    message: Not allowed
---
# The (empty) data handed to denyall at run time
apiVersion: "config.istio.io/v1alpha2"
kind: checknothing
metadata:
  name: denyrequest
  namespace: istio-system
spec:
---
# The rule that uses denier to deny requests with source.labels["app"] == "helloworld-ui"
apiVersion: "config.istio.io/v1alpha2"
kind: rule
metadata:
  name: deny-hello-world
  namespace: istio-system
spec:
  match: source.labels["app"]=="helloworld-ui"
  actions:
  - handler: denyall.denier
    instances:
    - denyrequest.checknothing
```

```sh
istioctl create -f guestbook/mixer-rule-denial.yaml
```

#### Block Access to v2 of the hello world service

```yaml
# Rule that re-uses denier to deny requests to version two of the hello world UI
apiVersion: "config.istio.io/v1alpha2"
kind: rule
metadata:
  name: deny-hello-world-v2
  namespace: istio-system
spec:
  match: source.labels["app"]=="helloworld-ui" && source.labels["version"] == "v2"
  actions:
  - handler: denyall.denier
    instances:
    - denyrequest.checknothing
```

```sh
istioctl create -f guestbook/mixer-rule-denial-v2.yaml
```

Then we clean up the rules to get everything working again:

```sh
istioctl delete -f guestbook/mixer-rule-denial.yaml
istioctl delete -f guestbook/mixer-rule-denial-v2.yaml
```

#### [Continue to Exercise 11 - Security](../exercise-11/README.md)
