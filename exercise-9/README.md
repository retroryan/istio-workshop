## Exercise 9 - Creating a Service Mesh with Istio Proxy

#### What is a Service Mesh?

Cloud Native Applications require a new approach to managing the communication between each service.  This problem is best solved by creating a dedicated infrastructure layer that handles service-to-service communication. With Istio this infrastructure layer is created by deploying a lightweight proxy alongside each application service.  It is done in a way that the application does not need to be aware of the proxy.

By moving the service communication to a separate layer it provides a separation of concerns where the monitoring, management and security of communication can be handled outside of the application logic.

#### Istio Proxy Side Car

To create a service mesh with Istio we update the deployment of the Pods to add the Istio Proxy (based on the Lyft Envoy Proxy) as a side car to each Pod.  The Proxy is then run as a separate container that manages all communication with that Pod.  This can be done either manually or with the latest version of Kubernetes automatically.

Manually the side car can be injected by running the istioctl kube-inject command which modifies the yaml file before creating the deployments.  This injects the Proxy into the deployment by updating the YAML to add the Proxy as a sidecar.  When this command is used the microservices are now packaged with an Proxy sidecar that manages incoming and outgoing calls for the service.  

Istio sidecars can also be automatically injected into a Pod before deployment using an alpha feature in Kubernetes called Initializers.  We will not be covering that feature in this workshop.

To see how the deployment yaml is modified run the following command:

`istioctl kube-inject -f helloworld-deployment.yaml`

#### Deploy all of the Guest Book Services to get started

1 - Start the Guest Book services using the following script:

```
guestbook/deployGuestBookIstio.sh
```

2 - You can access the public IP of the HelloWorld UI by running describe on the service and look for LoadBalancer Ingress IP in the output in a minute or two:

`kubectl describe services helloworld-ui`

3 - You can now access the guestbook via the helloworld ui ingress IP address by navigating the browser to http://INGRESS_IP/.

4 - The hello world ui also has a rest endpoint that we will use for testing routing rules.  It takes the last part of the URL as the name to create a greeting for.  Verify it works by running:

`curl http://INGRESS_IP/echo/universe`



#### [Continue to Exercise 10 - Canary Deployments and Fault Injection](../exercise-10/README.md)
