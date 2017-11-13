## Exercise 10 - Telemetry and Rate Limiting with Mixer

#### Instal Istio Monitoring and Metrics Tools

First we'll install some addons that Istio ships with, so we can get more insight into what's happening in our app:
```sh
kubectl apply -f istio-0.2.12/install/kubernetes/addons/prometheus.yaml
kubectl apply -f istio-0.2.12/install/kubernetes/addons/grafana.yaml
kubectl apply -f istio-0.2.12/install/kubernetes/addons/servicegraph.yaml
kubectl apply -f istio-0.2.12/install/kubernetes/addons/zipkin.yaml
```

#### Adding Telemetry Rules

Validate that the selected service has no service-specific rules already applied.

```sh
istioctl mixer rule get helloworld-ui.default.svc.cluster.local helloworld-ui.default.svc.cluster.local

Error: the server could not find the requested resource
```

Push the new configuration to Mixer for a specific service.

```sh
istioctl mixer rule create helloworld-service.default.svc.cluster.local helloworld-service.default.svc.cluster.local -f telemetry_rule.yaml
istioctl mixer rule create helloworld-ui.default.svc.cluster.local helloworld-ui.default.svc.cluster.local -f telemetry_rule.yaml
```

If the service had service-specific rules you would want to add them to the telemetry rules.

Send traffic to that hello world ui service by either going to the web page or using the curl command. Refresh the page several times or issue the curl command a few times to generate traffic.

```sh
watch curl http://$INGRESS_IP/echo/dog2 -A mobile
```

Verify that the new metric is being collected. Browse to the Grafana dashboard by viewing the Kubernetes services and finding the external IP. Then view it in your browser: `http://<Grafana IP>/dashboard/db/istio-dashboard`

#### Apply Across the Service mesh

But...that’s tedious to do for every service in your mesh. Instead, let’s apply our telemetry configuration to the whole mesh:

```sh
istioctl mixer rule create global global -f global_telemetry.yaml
```

(Note: we have to use a different config file because in 0.1 Mixer rules are full document writes; in 0.2 configuration is much more granular)

We can also see the logs Mixer creates for our services:

```sh
kubectl logs $(kubectl get pods -l istio=mixer -o jsonpath='{.items[0].metadata.name}') | grep \"combined_log\"
```

#### Rate Limiting with Mixer

Then apply a 1 request per second rate limit from the UI to the helloworld-service

```sh
istioctl mixer rule create global helloworld-service.default.svc.cluster.local -f rate-limit-ui-service.yaml
```

Then we can drive traffic to the UI to see the rate limit in action:
```sh
watch -n 0.1 curl -i $INGRESS_IP/echo/foo
```
and in Grafana we can see the 429’s: `http://<Grafana IP>/dashboard/db/istio-dashboard`
