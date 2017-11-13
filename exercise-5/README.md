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
export PATH=$PWD/istio-0.2.12/bin:$PATH
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

Change to the Istio directory (istio-0.2.12) and and install istio in the kubernetes cluster

For this workshop we use istio-auth.yaml enable mutual TLS authentication between sidecars.:

```sh
  kubectl apply -f install/kubernetes/istio-auth.yaml
```

####  Install Add-ons for Grafana, Prometheus, and Zipkin:

```sh
  cd istio-0.2.12
  kubectl apply -f install/kubernetes/addons/zipkin.yaml
  kubectl apply -f install/kubernetes/addons/grafana.yaml
  kubectl apply -f install/kubernetes/addons/prometheus.yaml
  kubectl apply -f install/kubernetes/addons/servicegraph.yaml
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
