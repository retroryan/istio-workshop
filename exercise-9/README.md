## Exercise 9 - Creating a Service Mesh with Istio Proxy

#### What is a Service Mesh?

Cloud Native Applications require a new approach to managing the communication between each service.  This problem is best solved by creating a dedicated infrastructure layer that handles service-to-service communication. With Istio this infrastructure layer is created by deploying a lightweight proxy alongside each application service.  It is done in a way that the application does not need to be aware of the proxy.

By moving the service communication to a separate layer it provides a separation of concerns where the monitoring, management and security of communication can be handled outside of the application logic.

#### Istio Proxy Side Car

To create a service mesh with Istio we update the deployment of the Pods to add the Istio Proxy (based on the Lyft Envoy Proxy) as a side car to each Pod.  The Proxy is then run as a separate container that manages all communication with that Pod.  This can be done either manually or with the latest version of Kubernetes automatically.

Manually the side car can be injected by running the istioctl kube-inject command which modifies the yaml file before creating the deployments.  This injects the Proxy into the deployment by updating the YAML to add the Proxy as a sidecar.  When this command is used the microservices are now packaged with an Proxy sidecar that manages incoming and outgoing calls for the service.  

Istio sidecars can also be automatically injected into a Pod before deployment using an alpha feature in Kubernetes called Initializers.  We will not be covering that feature in this workshop.

To see how the deployment yaml is modified run the following command:

```
    istioctl kube-inject -f guestbook/helloworld-deployment.yaml
```

Inside the yaml there is now an additional container:

```
  image: docker.io/istio/proxy_debug:0.2.9
  imagePullPolicy: IfNotPresent
  name: istio-proxy
```

This adds the Istio Proxy as an additional container to the Pod and setups the necessary configuration.

#### Deploy all of the Guest Book Services to get started

To deploy all of the guest book related components each deployment needs to be wrapped with a call to istioctl.  The following script does this for each of the components.

1 - Start the Guest Book services using the following script:

```
    guestbook/deployGuestBookIstio.sh
```

2 - Find the public IP of the Guest Book UI by running describe on the service and look for EXTERNAL-IP in the output (it will take several minutes to be assigned, so give it a minute or two):

```
    kubectl describe services guestbook-ui
```

3 - Access the guestbook via the Guest Book EXTERNAL-IP address by navigating the browser to http://EXTERNAL-IP/.

4 - The Guest Book UI also has a rest endpoint that can be used for testing routing rules.  It takes the last part of the URL as the name to create a greeting for.  Verify it works by running:

```
    curl http://EXTERNAL-IP/echo/universe
```

5 - Try curling the echo endpoint multiple times and notice how it round robins between v1 and v2 of the hello world service:

```
  $ curl 146.148.33.1/echo/universe

  {"greeting":{"hostname":"helloworld-service-v1-286408581-9204h","greeting":"Hello universe from helloworld-service-v1-286408581-9204h with 1.0","version":"1.0"},

  $ curl 146.148.33.1/echo/universe

  {"greeting":{"hostname":"helloworld-service-v2-1009285752-n2tpb","greeting":"Hello universe from helloworld-service-v2-1009285752-n2tpb with 2.0","version":"2.0"}

```

#### [Continue to Exercise 10 - Request Routing and Canary Deployments](../exercise-10/README.md)
