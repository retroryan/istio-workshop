## Exercise 5 - Installing Istio

#### Clean up

If you have anything running in Kubernetes from the previous exercises first remove those. The easiest way is to start with a clean slate and delete all deployed services from the cluster:

```sh
  kubectl delete all --all
```

#### Install Istio

We will follow the slightly modified GKE instructions from [installing Istio](https://cloud.google.com/istio/docs/how-to/installing-oss#install_istio)

1 - Be sure you are in the home directory:

```sh
      cd
```

2 - Run the following command to download and extract the Istio installation file and Istio client.

```sh
  curl -L https://git.io/getLatestIstio | ISTIO_VERSION=1.2.5 sh -
```

The installation directory contains:

* Installation .yaml files for Kubernetes in install
* Sample applications in samples
* The istioctl client binary in the bin/ directory. You can use istioctl to manually inject Envoy as a sidecar proxy and to create routing rules and policies.
* The istio.VERSION configuration file

2 - Ensure that you're in the Istio installation's root directory.

```sh
  cd ~/istio-1.2.5/
```

3 - Add the istioctl client to your PATH:

```sh
export PATH=$PWD/bin:$PATH
```

4 - Set up the istio-system namespace for Istio's control plane components:

```sh
kubectl create namespace istio-system
```

We will install Istio in the istio-system namespace you just created, and then manage microservices from all other namespaces. The installation includes Istio core components, tools, and samples.

5 - Install the Istio Custom Resource Definitions (CRDs) and wait a few seconds for the CRDs to be committed in the Kubernetes API server:

```sh
helm template install/kubernetes/helm/istio-init --name istio-init --namespace istio-system \
      --set grafana.enabled=true --set prometheus.enabled=true \
      --set tracing.enabled=true | kubectl apply -f -
```

6 - Verify that all 23 Istio CRDs were committed using the following command:

```
kubectl get crds | grep 'istio.io\|certmanager.k8s.io' | wc -l
```

It will take a minute to install the CRDs. After a minute you should see in the output:
23

7 - Install Istio with the [Demo Profile](https://istio.io/docs/setup/kubernetes/additional-setup/config-profiles/). Although you can choose another profile, we recommend the default profile for production deployments.

```sh
helm install install/kubernetes/helm/istio --name istio --namespace istio-system \
    --values install/kubernetes/helm/istio/values-istio-demo.yaml
```

This deploys the core Istio components:

* Istio-Pilot, which is responsible for service discovery and for configuring the Envoy sidecar proxies in an Istio service mesh.
* The Mixer components Istio-Policy and Istio-Telemetry, which enforce usage policies and gather telemetry data across the service mesh.
* Istio-Ingressgateway, which provides an ingress point for traffic from outside the cluster.
* Istio-Citadel, which automates key and certificate management for Istio.

And it also deploys the monitoring components.

8 - Verify Istio installation

Ensure the following Kubernetes Services are deployed: istio-citadel, istio-pilot, istio-ingressgateway, istio-policy, and istio-telemetry (you'll also see the other deployed services):

```sh
kubectl get service -n istio-system
```

In the output you should see istio-citadel, istio-galley, istio-ingressgateway, istio-pilot, istio-policy, istio-sidecar-injector, istio-statsd-prom-bridge, istio-telemetry and prometheus.

10 - Ensure the corresponding Kubernetes Pods are deployed and all containers are up and running: istio-pilot-*, istio-policy-*, istio-telemetry-*, istio-ingressgateway-*, and istio-citadel-*.*

```sh
kubectl get pods -n istio-system
```

```
    Output:
    NAME                                        READY     STATUS      RESTARTS   AGE
    istio-citadel-54f4678f86-4549b              1/1       Running     0          12m
    istio-cleanup-secrets-5pl77                 0/1       Completed   0          12m
    istio-galley-7bd8b5f88f-nhwlc               1/1       Running     0          12m
    istio-ingressgateway-665699c874-l62rg       1/1       Running     0          12m
    istio-pilot-68cbbcd65d-l5298                2/2       Running     0          12m
    istio-policy-7c5b5bb744-k6vm9               2/2       Running     0          12m
    istio-security-post-install-g9l9p           0/1       Completed   3          12m
    istio-sidecar-injector-85ccf84984-2hpfm     1/1       Running     0          12m
    istio-telemetry-5b6c57fffc-9j4dc            2/2       Running     0          12m
    istio-tracing-77f9f94b98-jv8vh              1/1       Running     0          12m
    prometheus-7456f56c96-7hrk5                 1/1       Running     0          12m
    ...
```


#### Running istioctl

Istio related commands need to have `istioctl` in the path. Verify it is available by running:

```sh
istioctl -h
```

#### What just happened?!

Congratulations! You have installed Istio into the Kubernetes cluster. A lot has been installed:
* Istio Controllers and related RBAC rules
* Istio Custom Resource Defintiions
* Prometheus and Grafana for Monitoring
* Jeager for Distributed Tracing
* Istio Sidecar Injector (we'll take a look next next section)

#### [Continue to Exercise 6 - Creating a Service Mesh with Istio Proxy](../exercise-6/README.md)
