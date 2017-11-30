# Exercise 6 - Creating a service mesh with Istio Proxy

### What is a service mesh?

Cloud-native applications require a new approach to managing the communication between each service. This problem is best solved by creating a dedicated infrastructure layer that handles service-to-service communication. With Istio, this infrastructure layer is created by deploying a lightweight proxy alongside each application service. This is done in a way that the application does not need to be aware of the proxy.

Moving the service communication to a separate layer provides a separation of concerns. The monitoring, management and security of communication can be handled outside of the application logic.

### What is a Kubernetes sidecar?

A Kubernetes pod is a group of containers, tied together for the purposes of administration and networking. Each pod can contain one or more containers.  Small containers are often used to provide common utilities for the pod. These sidecar containers extend and enhance the main container. Sidecar containers are a crosscutting concern and can be used across multiple pods.

### The Istio Proxy sidecar

To create a service mesh with Istio, you update the deployment of the pods to add the Istio Proxy (based on the Lyft Envoy Proxy) as a side car to each pod. The Proxy is then run as a separate container that manages all communication with that pod. This can be done either manually or with the latest version of Kubernetes automatically.

#### Manual sidecar injection

The side car can be injected manually by running the istioctl kube-inject command, which modifies the YAML file before creating the deployments. This injects the Proxy into the deployment by updating the YAML to add the Proxy as a sidecar. When this command is used, the microservices are now packaged with an Proxy sidecar that manages incoming and outgoing calls for the service. To see how the deployment YAML is modified, run thw following from the `istio-workshop` dir:

```sh
istioctl kube-inject -f guestbook/helloworld-deployment.yaml
```

This adds the Istio Proxy as an additional container to the Pod and setups the necessary configuration. Inside the YAML there is now an additional container:

```
image: docker.io/istio/proxy_debug:0.2.12
imagePullPolicy: IfNotPresent
name: istio-proxy
```

#### Automatic sidecar injection

Istio sidecars can also be automatically injected into a pod before deployment using an alpha feature in Kubernetes called Initializers. The istio-sidecar InitializerConfiguration is resource that specifies resources where Istio sidecar should be injected. By default, the Istio sidecar will be injected into deployments, statefulsets, jobs, and daemonsets. This is set up by running the following from the `istio-0.2.12` dir:

```sh
kubectl apply -f install/kubernetes/istio-initializer.yaml
```

This adds `sidecar.initializer.istio.io` to the Kubernetes list of pending initializers in the workload. The istio-initializer controller observes resources as they are deployed to Kubernetes and automatically injects the Istio Proxy sidecar by injecting the sidecar template.

### Deploy Guestbook services

To demonstrate Istio, we’re going to use [this guestbook example](https://github.com/retroryan/spring-boot-docker). This example is built with Spring Boot, a frontend using Spring MVC and Thymeleaf, and two microservices. The 3 microservices that we are going to deploy are:

* Hello World service - A simple service that returns a greeting back to the user.

* Guestbook service - A service that keeps a registry of guests and the message they left.

* Guestbook UI - The front end to the application that calls to the other microservices to get the list of guests, register a new guest, and get the greeting for the user when they register.

The guestbook example requires MySQL to store guestbook entries and Redis to store session information.

Note that the services must be started in a fixed order because they depend on other services being started first.

1. Deploy MySQL, Redis, the Hello World microservices, and the associated Kubernetes Services from the `istio-workshop` dir:

    ```sh
    cd ../istio-workshop
    kubectl apply -f guestbook/mysql-deployment.yaml -f guestbook/mysql-service.yaml
    kubectl apply -f guestbook/redis-deployment.yaml -f guestbook/redis-service.yaml
    kubectl apply -f guestbook/helloworld-deployment.yaml -f guestbook/helloworld-service.yaml
    kubectl apply -f guestbook/helloworld-deployment-v2.yaml
    ```

2. Verify that these microservices are available before continuing. **Do not procede until they are up and running.** 

    ```
    kubectl get -w deployment
    ```
    
3. Deploy the guestbook microservice.

    ```sh
    kubectl apply -f guestbook/guestbook-deployment.yaml -f guestbook/guestbook-service.yaml
    ```

4. Verify that guestbook is available before continuing. **Do not procede until the microservice is up and running.** 

    ```
    kubectl get -w deployment
    ```

5. Deploy the guestbook UI:

    ```sh
    kubectl apply -f guestbook/guestbook-ui-deployment.yaml -f guestbook/guestbook-ui-service.yaml
    ```

#### [Continue to Exercise 7 - Istio Ingress controller](../exercise-7/README.md)
