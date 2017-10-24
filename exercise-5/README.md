## Exercise 5 - Setup for Creating an Istio Ingress Controller

We are going to create a single Ingress Controller for the entire cluster.  This will eliminate the need for the services to have an external load balancer ip.

## Download Istio

Only download Istio - do not install it yet!

Either download it directly or get the latest:

https://github.com/istio/istio/releases

```
curl -L https://git.io/getLatestIstio | sh -
export PATH=$PWD/istoi-0.1.6/bin:$PATH
```

#### Running istioctl

Istio related commands need to have `istioctl` in the path.  Verify it is available by running:

`istioctl -h`

#### [Continue to Exercise 6 - Creating the Istio Ingress with the Pilot and Proxy](../exercise-6/README.md)
