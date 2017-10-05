## Exercise 8 - Full Install of Istio

#### Start with a clean slate and delete everything from the cluster

`kubectl delete all --all`

#### Install Istio

```
cd istio-0.1.6
kubectl apply -f install/kubernetes/istio.yaml
kubectl apply -f install/kubernetes/addons/prometheus.yaml
kubectl apply -f install/kubernetes/addons/grafana.yaml
kubectl apply -f install/kubernetes/addons/servicegraph.yaml
kubectl apply -f install/kubernetes/addons/zipkin.yaml
```


#### [Continue to Exercise 9 - Deploying Services with Istio](../exercise-9/README.md)
