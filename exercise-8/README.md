## Exercise 8 - Telemetry

First we need to configure Istio to automatically gather telemetry data for services running in the mesh.

This is done by adding Istio configuration that instructs Mixer to automatically generate and report a new metric and a new log stream for all traffic within the mesh.

The added configuration controlls three pieces of Mixer functionality:

* Generation of instances (in this example, metric values and log entries) from Istio attributes
* Creation of handlers (configured Mixer adapters) capable of processing generated instances
* Dispatch of instances to handlers according to a set of rules


The metrics configuration directs Mixer to send metric values to Prometheus. It uses three stanzas (or blocks) of configuration: instance configuration, handler configuration, and rule configuration.

#### Create a Rule to Collect Telemetry Data

```sh
istioctl create -f guestbook/guestbook-telemetry.yaml
```
#### View Guestbook Telemetry data

Generate a small load to the application either using wrk2 or a shell script:

For wrk2:

```sh
 brew install --HEAD jabley/wrk2/wrk2

wrk2 -d 500s -c 5 -t 5 -R 10 http://$INGRESS_IP/hello/world
```

Or a shell script:

```sh
while sleep 0.5; do curl http://$INGRESS_IP/hello/world; done
```

### Grafana
Establish port forward from local port 3000 to the Grafana instance:
```sh
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana \
  -o jsonpath='{.items[0].metadata.name}') 3000:3000
```

Browse to http://localhost:3000 and navigate to Istio Dashboard

### Prometheus
```sh
kubectl -n istio-system port-forward \
  $(kubectl -n istio-system get pod -l app=prometheus -o jsonpath='{.items[0].metadata.name}') \
  9090:9090
```

Browse to http://localhost:9090/graph and in the “Expression” input box enter: `istio_request_count`. Click the Execute button.


### Service Graph  - Broken in Istio 0.5.0

```sh
kubectl -n istio-system port-forward \
  $(kubectl -n istio-system get pod -l app=servicegraph -o jsonpath='{.items[0].metadata.name}') \
  8088:8088
```

Browse to http://localhost:8088/dotviz

#### Mixer Log Stream

The logs configuration directs Mixer to send log entries to stdout. It uses three stanzas (or blocks) of configuration: instance configuration, handler configuration, and rule configuration.


```sh
kubectl -n istio-system logs -f $(kubectl -n istio-system get pods -l istio=mixer -o jsonpath='{.items[0].metadata.name}') mixer | grep \"instance\":\"newlog.logentry.istio-system\"
```

#### [Continue to Exercise 9 - Distributed Tracing](../exercise-9/README.md)
