## Exercise 8 - Telemetry

#### Generate Guestbook Telemetry data

Generate a small load to the application either using wrk2 or a shell script:

For wrk2:

```sh
docker pull saturnism/wrk2
docker run -ti --rm saturnism/wrk2 \
  -d 500s -c 5 -t 5 http://$INGRESS_IP/hello/world
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

If you are in Cloud Shell, you'll need to use Web Preview and Change Port to `3000`. Else, browse to http://localhost:3000 and navigate to Istio Dashboard

### Prometheus
```sh
kubectl -n istio-system port-forward \
  $(kubectl -n istio-system get pod -l app=prometheus -o jsonpath='{.items[0].metadata.name}') \
  9090:9090
```

If you are in Cloud Shell, you'll need to use Web Preview and Change Port to `9090`.  Else, browse to http://localhost:9090/graph and in the “Expression” input box enter: `istio_request_count`. Click the Execute button.

### Service Graph

```sh
kubectl -n istio-system port-forward \
  $(kubectl -n istio-system get pod -l app=servicegraph -o jsonpath='{.items[0].metadata.name}') \
  8088:8088
```

If you are in Cloud Shell, you'll need to use Web Preview and Change Port to `9090`. Once opened, you'll see `404 not found` error. This is normal because `/` is not handled. Append the URI with `/dotviz`, e.g.: `http://8088-dot-...-dot-devshell.appspot.com/dotviz`

Else, browse to http://localhost:8088/dotviz

#### [Continue to Exercise 9 - Distributed Tracing](../exercise-9/README.md)
