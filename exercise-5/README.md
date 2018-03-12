## Exercise 5 - Installing Istio 0.6.0

#### Clean up

Start with a clean slate and delete all deployed services from the cluster:

```sh
kubectl delete all --all
```

#### Download Istio 0.6.0

Download Istio 0.6.0 from the following website:

https://github.com/istio/istio/releases/tag/0.6.0

For example, in Cloud Shell, you can install Istio to the home directory:

```sh
cd ~/
wget https://github.com/istio/istio/releases/download/0.6.0/istio-0.6.0-linux.tar.gz
tar -xzvf istio-0.6.0-linux.tar.gz
ln -sf ~/istio-0.6.0 ~/istio
```

```sh
export PATH=~/istio/bin:$PATH
```

Also, save it in `.bashrc` in case you restart your shell:
```sh
echo 'export PATH=~/istio/bin:$PATH' >> ~/.bashrc
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

For this workshop we are not using Istio Auth because we want to test using outside services accessing the cluster.  Istio Auth enables mutual TLS authentication between pods but it prevents the ability to access the services outside the cluster.

To install plain istio run:

```sh
kubectl apply -f ~/istio/install/kubernetes/istio.yaml
```


####  Install Add-ons for Grafana, Prometheus, and Zipkin:

```sh
kubectl apply -f ~/istio/install/kubernetes/addons/zipkin.yaml
kubectl apply -f ~/istio/install/kubernetes/addons/grafana.yaml
kubectl apply -f ~/istio/install/kubernetes/addons/prometheus.yaml
kubectl apply -f ~/istio/install/kubernetes/addons/servicegraph.yaml
```

#### Viewing the Istio Deployments

Istio is deployed in a separate Kubernetes namespace `istio-system`  You can watch the state of Istio and other services and pods using the watch flag (`-w`) when listing Kubernetes resources. For example, in two separate terminal windows run:

```sh
kubectl get pods -n istio-system -w
kubectl get services -n istio-system -w
```

#### [Continue to Exercise 6 - Creating a Service Mesh with Istio Proxy](../exercise-6/README.md)
