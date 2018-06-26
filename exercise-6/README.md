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

Istio sidecars can also be automatically injected into a pod at creation time using a feature in Kubernetes called a mutating webhook admission controller.   Note that unlike manual injection, automatic injection occurs at the pod-level. You won't see any change to the deployment itself. Instead you'll want to check individual pods (via kubectl describe) to see the injected proxy.

An admission controller is a piece of code that intercepts requests to the Kubernetes API server prior to persistence of the object, but after the request is authenticated and authorized. Admission controllers may be “validating”, “mutating”, or both. Mutating controllers may modify the objects they admit; validating controllers may not.

The admission control process proceeds in two phases. In the first phase, mutating admission controllers are run. In the second phase, validating admission controllers are run.

MutatingWebhookConfiguration describes the configuration of and admission webhook that accept or reject and may change the object.  

For Istio the webhook is the sidecar injector webhook deployment called "istio-sidecar-injector".  It will modify a pod before it is started to inject an istio init container and istio proxy container.

#### Using the Sidecar Injector

By default, Istio is configured to apply a sidecar injector to namespaces with the label/value of `istio-injection=enabled`.

Label the default namespace with `istio-injection` label set to `enabled`.

```sh
kubectl label namespace default istio-injection=enabled
```

Check that the label is applied.

```sh
kubectl get namespace -L istio-injection

NAME           STATUS    AGE       ISTIO-INJECTION
default        Active    1h        enabled
istio-system   Active    1h        
kube-public    Active    1h        
kube-system    Active    1h
```

### Deploy Guestbook services

To demonstrate Istio, we’re going to use [this guestbook example](https://github.com/saturnism/istio-by-example-java/tree/master/spring-boot2-example). This example is built with Spring Boot, a frontend using Spring MVC and Thymeleaf, and two microservices. The 3 microservices that we are going to deploy are:

* Hello World service - A simple service that returns a greeting back to the user.
* Guestbook service - A service that keeps a registry of guests and the message they left.
* Guestbook UI - The front end to the application that calls to the other microservices to get the list of guests, register a new guest, and get the greeting for the user when they register.

The guestbook example requires MySQL to store guestbook entries and Redis to store session information.

Note that the services must be started in a fixed order because they depend on other services being started first.

1. Deploy MySQL, Redis, the Hello World microservices, and the associated Kubernetes Services from the `istio-workshop` dir:

    ```sh
    cd ~/istio-workshop
    kubectl apply -f kubernetes/
    ```

2. Notice that each of the pods now has one Istio init container and two running containers. One is the main application container and the second is the istio proxy container.

    ```sh
    kubectl get pod
    ```

    When you get the pods you should see in the READY column 2/2 meaning that 2 of 2 containers are in the running state (it might take a minute or two to get to that state).  

    When you describe the pod what that shows is the details of the additional containers.

    ```sh
    kubectl describe pods helloworld-service-v1.....
    ```

3. Verify that previous deployments are all in a state of AVAILABLE before continuing. **Do not procede until they are up and running.**

    ```sh
    kubectl get -w deployment
    ```

4. Access the guestbook UI in the web browser:

The Guestbook UI Kubernetes service has a type of LoadBalancer.  This creates an external IP through which the UI can be accessed:

```sh
kubectl get svc guestbook-ui

NAME           TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)        AGE
guestbook-ui   LoadBalancer   10.59.245.13   35.197.94.184   80:30471/TCP   2m
```

You can test access via a web browser and curl.  You should be able to navigate to that IP to access the Guestbook UI.

To `curl` the Guestbook UI endpoint use:

```sh
curl 35.230.4.192
```

You can also open it up in a browser.

4.  Inspect the details of the pods

Look at the details of the pod and then inspect the envoy config:

```
kubectl describe pod helloworld-service-v1.....
kubectl exec -it helloworld-service-v1..... -c istio-proxy bash
cd /etc/istio/proxy
more envoy-rev0.json
exit
```

#### [Continue to Exercise 7 - Istio Ingress controller](../exercise-7/README.md)
