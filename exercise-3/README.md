## Exercise 3 - Creating a Kubernetes Service

Each Pod has a unique IP address - but the address is ephemeral. The Pod IP addresses are not stable and it can change when Pods start and/or restart. A service provides a single access point to a set of pods matching some constraints. A Service IP address is stable.

In Kubernetes, you can instruct the underlying infrastructure to create an external load balancer, by specifying the Service Type as a LoadBalancer. If you open up [helloworldservice-service.yaml](helloworldservice-service.yaml) you will see that it has a type: LoadBalancer

#### Create the Hello World Service “service”

```sh
kubectl apply -f kubernetes/helloworldservice-service.yaml --record
```

```sh
kubectl get services

NAME                 TYPE           CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE
helloworld-service   LoadBalancer   10.0.0.208   <pending>     8080:31771/TCP   9s
```

The external ip will start as pending. After a short period the EXTERNAL IP will be populated.  This is the external IP of the Load Balancer.  

#### Curl the external ip to test the helloworld service:

```sh
curl http://104.154.120.67:8080/hello/world
```

#### Explanation
#### By Ray Tsang [@saturnism](https://twitter.com/saturnism)

Open the [helloworldservice-service.yaml](helloworldservice-service.yaml) to examine the service descriptor. The important part about this file is the selector section. This is how a service knows which pod to route the traffic to, by matching the selector labels with the labels of the pods.

The other important part to notice in this file is the type of service is a Load Balancer. This tells GCE that an externally facing load balancer should be created for this service so that it is accessible from the outside.

Since we are running two instances of the Hello World Service (one instance in one pod), and that the IP addresses are not only unique, but also ephemeral - how will a client reach our services? We need a way to discover the service.

In Kubernetes, Service Discovery is a first class citizen. We created a Service that will:
act as a load balancer to load balance the requests to the pods, and
provide a stable IP address, allow discovery from the API, and also create a DNS name!

#### Optional - curl the service using a DNS name

If you login into another container you can access the helloworldservice via the DNS name. For example start a new tutum/curl container to get a shell and curl the service using the service name:

```sh
$ kubectl run curl --image=tutum/curl -i --tty --rm

root@curl-797905165-015t4:/# curl http://helloworld-service:8080/hello/Batman
{"greeting":"Hello Batman from helloworld-service-... with 1.0","hostname":"helloworld-service-...","version":"1.0"}

root@curl-797905165-015t4:/# exit
```

#### [Continue to Exercise 4 - Scaling In and Out](../exercise-4/README.md)
