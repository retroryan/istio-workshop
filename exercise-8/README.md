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

$ kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=grafana -o jsonpath='{.items[0].metadata.name}') 3000:3000 &

If you are in Cloud Shell, you'll need to use Web Preview and Change Port to `3000`.

Browse to http://localhost:3000 and navigate to the different Istio Dashboards. On the left select the "Dashboards" logo, then click "Manage", then select the "Istio Mesh Dashboard" and "Istio Performance Dashboard"

### Prometheus
```sh
kubectl -n istio-system port-forward \
  $(kubectl -n istio-system get pod -l app=prometheus -o jsonpath='{.items[0].metadata.name}') \
  9090:9090
```

If you are in Cloud Shell, you'll need to use Web Preview and Change Port to `9090`.  

Browse to http://localhost:9090/graph and in the “Expression” input box enter: `istio_request_bytes_count`. Click the Execute button.

### Service Graph

The service graph functionality has been replaced with Kiali.  For more details see:

[Visualizing Your Mesh](https://istio.io/docs/tasks/telemetry/kiali/)

#### [Continue to Exercise 9 - Distributed Tracing](../exercise-9/README.md)
