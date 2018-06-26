## Exercise 8 - Telemetry

#### Generate Guestbook Telemetry data

Generate a small load to the application either using a shell script or fortio:

With simple shell script:

```sh
while sleep 0.5; do curl http://$INGRESS_IP; done
```

Or, with fortio:

```sh
docker run istio/fortio load -t 5m -qps 5 \
  http://$INGRESS_IP
```

### Grafana

Establish port forward from local port 3000 to the Grafana instance:
```sh
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana \
  -o jsonpath='{.items[0].metadata.name}') 3000:3000
```

If you are in Cloud Shell, you'll need to use Web Preview and Change Port to `3000`.

Browse to http://localhost:3000 and navigate to Istio Dashboard (on the left select the "Dashboards" logo, then click "Manage", then select the "Istio Dashboard")

### Prometheus
```sh
kubectl -n istio-system port-forward \
  $(kubectl -n istio-system get pod -l app=prometheus -o jsonpath='{.items[0].metadata.name}') \
  9090:9090
```

If you are in Cloud Shell, you'll need to use Web Preview and Change Port to `9090`.  

Browse to http://localhost:9090/graph and in the “Expression” input box enter: `istio_request_count`. Click the Execute button.

### Service Graph

```sh
kubectl -n istio-system port-forward \
  $(kubectl -n istio-system get pod -l app=servicegraph -o jsonpath='{.items[0].metadata.name}') \
  8088:8088
```

If you are in Cloud Shell, you'll need to use Web Preview and Change Port to `8088`. Once opened, you'll see `404 not found` error. This is normal because `/` is not handled. Append the URI with `/force/forcegraph.html`, e.g.: `http://8088-dot-...-dot-devshell.appspot.com/force/forcegraph.html`

If not in Cloud Shell, then browse to http://localhost:8088/force/forcegraph.html

#### [Continue to Exercise 9 - Distributed Tracing](../exercise-9/README.md)
