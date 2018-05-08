## Exercise 8a - Additional Telemetry and Log

First we need to configure Istio to automatically gather telemetry data for services running in the mesh.

This is done by adding Istio configuration that instructs Mixer to automatically generate and report a new metric and a new log stream for all traffic within the mesh.

The added configuration controls three pieces of Mixer functionality:

* Generation of instances (in this example, metric values and log entries) from Istio attributes
* Creation of handlers (configured Mixer adapters) capable of processing generated instances
* Dispatch of instances to handlers according to a set of rules

The metrics configuration directs Mixer to send metric values to Prometheus. It uses three stanzas (or blocks) of configuration: instance configuration, handler configuration, and rule configuration.

#### Create a Rule to Collect Telemetry Data

```sh
istioctl create -f guestbook/guestbook-telemetry.yaml
```

#### Mixer Log Stream

The logs configuration directs Mixer to send log entries to stdout. It uses three stanzas (or blocks) of configuration: instance configuration, handler configuration, and rule configuration.

```sh
kubectl -n istio-system logs -f $(kubectl -n istio-system get pods -l istio=mixer -o jsonpath='{.items[0].metadata.name}') mixer | grep \"instance\":\"newlog.logentry.istio-system\"
```

#### [Continue to Exercise 9 - Distributed Tracing](../exercise-9/README.md)
