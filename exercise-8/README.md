## Exercise 8 - Telemetry

First we need to configure Istio to automatically gather telemetry data for services running in the mesh.

#### Create a Rule to Collect Telemetry Data

```sh
istioctl create -f guestbook/guestbook-telemetry.yaml
```
#### View Guestbook Telemetry data

Generate a small load to the application:

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

### Zipkin
Establish port forward from local port
```sh
kubectl port-forward -n istio-system \
  $(kubectl get pod -n istio-system -l app=zipkin -o jsonpath='{.items[0].metadata.name}') \
  9411:9411
```

Browse to http://localhost:9411

### Prometheus
```sh
kubectl -n istio-system port-forward \
  $(kubectl -n istio-system get pod -l app=prometheus -o jsonpath='{.items[0].metadata.name}') \
  9090:9090
```

Browse to http://localhost:9090/graph and in the “Expression” input box enter: `istio_request_count`. Click the Execute button.


### Service Graph
```sh
kubectl -n istio-system port-forward \
  $(kubectl -n istio-system get pod -l app=servicegraph -o jsonpath='{.items[0].metadata.name}') \
  8088:8088
```

Browse to http://localhost:8088/dotviz

#### Mixer Log Stream

```sh
kubectl -n istio-system logs $(kubectl -n istio-system get pods -l istio=mixer -o jsonpath='{.items[0].metadata.name}') mixer | grep \"instance\":\"newlog.logentry.istio-system\"
```

#### [Continue to Exercise 9 - Request Routing and A/B Testing](../exercise-9/README.md)
