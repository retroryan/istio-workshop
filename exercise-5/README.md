## Exercise 5 - Installing Istio

#### Clean up

If you have anything running in Kubernetes from the previous exercises first remove those. The easiest way is to start with a clean slate and delete all deployed services from the cluster:

```sh
kubectl delete all --all
```

#### Install Istio

1. Download Istio CLI and release.

```sh
cd ~/
export ISTIO_VERSION=1.0.3
curl -L https://git.io/getLatestIstio | sh -
ln -sf istio-$ISTIO_VERSION istio
```

2. Add Istio binary path to $PATH.

```sh
export PATH=~/istio/bin:$PATH
```

Also, save it in `.bashrc` in case you restart your shell. On linux:

```sh
echo 'export PATH=~/istio/bin:$PATH' >> ~/.bashrc
```

Or on a mac:

```sh
echo 'export PATH=~/istio/bin:$PATH' >> ~/.bash_profile
```


#### Running istioctl

Istio related commands need to have `istioctl` in the path. Verify it is available by running:

```sh
istioctl -h
```

#### Install Istio on the Kubernetes Cluster

For this workshop we are not using Istio Auth because we want to test using outside services accessing the cluster.  Istio Auth enables mutual TLS authentication between pods but it prevents the ability to access the services outside the cluster and will require additional configurations.

To install plain Istio run:

```sh
kubectl apply -f ~/istio/install/kubernetes/helm/istio/templates/crds.yaml

kubectl apply -f ~/istio/install/kubernetes/istio-demo.yaml \
    --as=admin --as-group=system:masters
```


#### Viewing the Istio Deployments

Istio is deployed in a separate Kubernetes namespace `istio-system`.  You can watch the state of Istio and other services and pods using the watch flag (`-w`) when listing Kubernetes resources. For example, in two separate terminal windows run:

```sh
watch -n30 kubectl get pods -n istio-system
watch -n30 kubectl get services -n istio-system
```

#### What just happened?!

Congratulations! You have installed Istio into the Kubernetes cluster. A lot has been installed:
* Istio Controllers and related RBAC rules
* Istio Custom Resource Defintiions
* Prometheus and Grafana for Monitoring
* Jeager for Distributed Tracing
* Istio Sidecar Injector (we'll take a look next next section)

#### [Continue to Exercise 6 - Creating a Service Mesh with Istio Proxy](../exercise-6/README.md)
