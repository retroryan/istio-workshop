## Exercise 7 - Request Routing with Istio Route Rules

The Istio Ingress Controller provides a [complete set of rules](https://istio.io/docs/concepts/traffic-management/rules-configuration.html) that use Envoy's traffic management capabilities. These exercises will show how to dynamically configure the Istio Ingress Controller by sumbitting commands to the Istio Pilot using the istioctl command line tool.

If you do not have the istioctl command line tool go back to [exercise-5](../exercise-5/#download-istio) and download Istio.

As an example we are going to deploy a V2 of the hello world service and see what happens with the current Ingress Rules.

#### Deploy Hello World Service V2

Deploy V2 of Hello World Service from this deployment description - [helloworldservice-deployment-v2.yaml](helloworldservice-deployment-v2.yaml)

`kubectl create -f helloworldservice-deployment-v2.yaml`

#### Kubernetes service behavior of round robining between Services

If we curl the service over and over we will see the it round robins between the version of the services:

```
$ curl 104.155.181.0/hello/world
{"greeting":"Hello world from helloworld-service-v1-986699223-758r0 with 1.0","hostname":"helloworld-service-v1-986699223-758r0","version":"1.0"}
$ curl 104.155.181.0/hello/world
{"greeting":"Hello world from helloworld-service-v2-190019907-k10vk with 2.0","hostname":"helloworld-service-v2-190019907-k10vk","version":"2.0"}
$ curl 104.155.181.0/hello/world
{"greeting":"Hello world from helloworld-service-v1-986699223-758r0 with 1.0","hostname":"helloworld-service-v1-986699223-758r0","version":"1.0"}
$ curl 104.155.181.0/hello/world
{"greeting":"Hello world from helloworld-service-v2-190019907-k10vk with 2.0","hostname":"helloworld-service-v2-190019907-k10vk","version":"2.0"}
$ curl 104.155.181.0/hello/world
{"greeting":"Hello world from helloworld-service-v1-986699223-758r0 with 1.0","hostname":"helloworld-service-v1-986699223-758r0","version":"1.0"}
```

What we see is that the service is load balancing the traffic in a round robin fashion between the two versions of the hello world service.  What we want to do is force all the traffic to a single version of the service by using a routing rule.

#### Create a routing rules

Force all the traffic to a single version of the service by creating a routing rule using `istioctl`:

`istioctl create -f force-hello-v1.yaml`

Look at how this [routing rule](force-hello-v1.yaml) is forcing all the traffic to V1 of the service.

Try curling the service as before and verify you only see v1 of the service.

#### Only route 20% of the traffic to the new service

You can route traffic based on weights.  In this example we will route 20% of the traffic to the new service.

`istioctl create -f route-80-20.yaml`

#### [Continue to Exercise 8 - Full Install of Istio](../exercise-8/README.md)
