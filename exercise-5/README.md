## Exercise 5 - Installing Istio

#### Clean up

Start with a clean slate and delete all deployed services from the cluster:

```sh
kubectl delete all --all
```

#### Download Istio

Either download it directly or get the latest using curl:

https://github.com/istio/istio/releases

```sh
curl -L https://git.io/getLatestIstio | sh -
```
```sh
export PATH=$PWD/istio-0.5.1/bin:$PATH
```

#### Running istioctl

Istio related commands need to have `istioctl` in the path. Verify it is available by running:

```sh
istioctl -h
```

#### Install Istio on the Kubernetes Cluster

1 - First grant cluster admin permissions to the current user (admin permissions are required to create the necessary RBAC rules for Istio):

```sh
kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole=cluster-admin \
    --user=$(gcloud config get-value core/account)
```
2 - Next install Istio on the Kubernetes cluster:

For this workshop we are not using Istio Auth because we want to test using outside services accessing the cluster.  Istio Auth enables mutual TLS authentication between pods.

To install plain istio run:

```sh
kubectl apply -f istio-0.5.1/install/kubernetes/istio.yaml
```


####  Install Add-ons for Grafana, Prometheus, and Zipkin:

WARNING!! The prometheus yaml needs to be patched!

In the file istio-0.5.1/install/kubernetes/addons/prometheus.yaml update the following stanza to add the correct namespace:

apiVersion: v1
kind: ServiceAccount
metadata:
  name: prometheus
  namespace: istio-system

```sh
kubectl apply -f istio-0.5.1/install/kubernetes/addons/zipkin.yaml
kubectl apply -f istio-0.5.1/install/kubernetes/addons/grafana.yaml
kubectl apply -f istio-0.5.1/install/kubernetes/addons/prometheus.yaml
kubectl apply -f istio-0.5.1/install/kubernetes/addons/servicegraph.yaml
```

#### Viewing the Istio Deployments

Istio is deployed in a separate Kubernetes namespace `istio-system`  You can watch the state of Istio and other services and pods using the watch flag (`-w`) when listing Kubernetes resources. For example, in two separate terminal windows run:

```sh
kubectl get pods -w --all-namespaces
```
```sh
kubectl get services -w --all-namespaces
```

#### [Continue to Exercise 6 - Creating a Service Mesh with Istio Proxy](../exercise-6/README.md)
