## Exercise 6 - Creating a Service Mesh with Istio Proxy

#### What is a Service Mesh?

Cloud Native Applications require a new approach to managing the communication between each service. This problem is best solved by creating a dedicated infrastructure layer that handles service-to-service communication. With Istio this infrastructure layer is created by deploying a lightweight proxy alongside each application service. It is done in a way that the application does not need to be aware of the proxy.

By moving the service communication to a separate layer it provides a separation of concerns where the monitoring, management and security of communication can be handled outside of the application logic.

#### What is a Kubernetes Side Car?

A Kubernetes pod is a group of containers, tied together for the purposes of administration and networking. Each pod can contain one or more containers.  Small containers are often used to provide common utilities for the Pod.  These sidecar containers extend and enhance the main container. Sidecar containers are a cross cutting concern and can be used across multiple Pods.

#### Istio Proxy Side Car

To create a service mesh with Istio we update the deployment of the Pods to add the Istio Proxy (based on the Lyft Envoy Proxy) as a side car to each Pod. The Proxy is then run as a separate container that manages all communication with that Pod. This can be done either manually or with the latest version of Kubernetes automatically.

Manually the side car can be injected by running the istioctl kube-inject command which modifies the yaml file before creating the deployments. This injects the Proxy into the deployment by updating the YAML to add the Proxy as a sidecar. When this command is used the microservices are now packaged with an Proxy sidecar that manages incoming and outgoing calls for the service.


To see how the deployment yaml is modified run the following command from the `istio-workshop` dir:

```sh
istioctl kube-inject -f guestbook/helloworld-deployment.yaml
```

Inside the yaml there is now an additional container:

```
image: docker.io/istio/proxy_debug:0.2.12
imagePullPolicy: IfNotPresent
name: istio-proxy
```

This adds the Istio Proxy as an additional container to the Pod and setups the necessary configuration.

#### Automatic sidecar injection

Istio sidecars can also be automatically injected into a Pod before deployment using an alpha feature in Kubernetes called Initializers.  The istio-sidecar InitializerConfiguration is resource that specifies resources where Istio sidecar should be injected. By default the Istio sidecar will be injected into deployments, statefulsets, jobs, and daemonsets.  This is setup by running the following from the `istio-0.2.12` dir:

```sh
kubectl apply -f istio-0.2.12/install/kubernetes/istio-initializer.yaml
```

This adds `sidecar.initializer.istio.io` to Kubernetes list of pending initializers in the workload. The istio-initializer controller observes resources as they are deployed to Kubernetes and automatically injects the Istio Proxy sidecar by injecting the sidecar template.

#### Deploy Guest Book Services

For demonstrating Istio we’re going to use [this guestbook example](https://github.com/retroryan/spring-boot-docker). This example is built with Spring Boot, with a frontend using Spring MVC and Thymeleaf, and two microservices.  The 3 microservices that we are going to deploy are:

* Hello World Service - A simple service that returns a greeting back to the user.

* Guestbook Service - A service that keeps a registry of guests and the message they left.

* Hello World UI - The front end to the application that calls to the other microservices to get the list of guests, register a new guest and get the greeting for the user when they register.

It requires MySQL to store guestbook entries, and Redis to store session information.   

Note that the services have to be started in a fixed order because they depend on other services being started.

1 - Deploy MySQL, Redis and the Hello World microservices and the associated Kubernetes Services from the `istio-workshop` dir:

```sh
kubectl apply -f guestbook/mysql-pvc.yaml  -f guestbook/mysql-deployment.yaml -f guestbook/mysql-service.yaml
kubectl apply -f guestbook/redis-deployment.yaml -f guestbook/redis-service.yaml
kubectl apply -f guestbook/helloworld-deployment.yaml -f guestbook/helloworld-service.yaml
kubectl apply -f guestbook/helloworld-deployment-v2.yaml
```

BE SURE TO WAIT FOR ALL OF THESE SERVICES TO BE RUNNING BEFORE CONTINUING!!!  (Hint: `kubectl get -w deployment`)

2 - Deploy the Guest Book microservice:

```sh
kubectl apply -f guestbook/guestbook-deployment.yaml -f guestbook/guestbook-service.yaml
```

WAIT FOR GUESTBOOK TO BE RUNNING!!  (Hint: `kubectl get -w deployment`)

3 - Deploy the Guide Book UI:

```sh
kubectl apply -f guestbook/guestbook-ui-deployment.yaml -f guestbook/guestbook-ui-service.yaml
```

#### [Continue to Exercise 7 - Istio Ingress Controller](../exercise-7/README.md)
