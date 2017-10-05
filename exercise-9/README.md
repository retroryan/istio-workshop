## Exercise 9 - Deploying Services with Istio

#### Istio Proxy Side Car

When we deploy the services with Istio the primary difference is each pod needs to be run with the Envoy Proxy.  This is done by running  the istioctl kube-inject command which modifies the yaml file before creating the deployments.  This injects Envoy into Kubernetes resources as documented here.   By using this command all of the microservices are now packaged with an Envoy sidecar that manages incoming and outgoing calls for the service.  

`istioctl kube-inject -f helloworld-deployment.yaml`

#### Deploy all of the Guest Book Services to get started

Start the following services and wait for them to come up by watching the pods

```
kubectl apply -f guestbook/mysql-pvc.yaml -f <(istioctl kube-inject -f guestbook/mysql-deployment.yaml) -f guestbook/mysql-service.yaml
kubectl apply -f <(istioctl kube-inject -f guestbook/redis-deployment.yaml) -f guestbook/redis-service.yaml
kubectl apply -f <(istioctl kube-inject -f guestbook/helloworld-deployment.yaml) -f guestbook/helloworld-service.yaml
kubectl apply -f <(istioctl kube-inject -f guestbook/helloworld-deployment-v2.yaml)
kubectl get pods
```

Wait for the pods to be in running state

`kubectl apply -f <(istioctl kube-inject -f guestbook/guestbook-deployment.yaml) -f guestbook/guestbook-service.yaml`

Wait for the guestbook pod to be in running state.  You know the drill by now. We first need to create the deployment that will start and manage the frontend pods, followed by exposing the service.  

`kubectl apply -f <(istioctl kube-inject -f ui-deployment.yaml) -f ui-service.yaml`

You can  access the public IP by running describe on the service and look for LoadBalancer Ingress IP in the output in a minute or two:

`kubectl describe services helloworld-ui`

You can now access the guestbook via the ingress IP address by navigating the browser to http://INGRESS_IP/.

The hello world ui also has a rest endpoint that we will use for testing routing rules.  It takes the last part of the URL as the name to create a greeting for.  Verify it works by running:

`curl http://INGRESS_IP/echo/universe`


You can delete and re-create any of the example services with a type of Load Balancer to be able to test out that service directly.  For example if you modify the hello world service to have a type of load balancer you can curl it directly:

`curl http://HELLO_WORLD_SVC_IP/hello/someone`

#### Istio Ingress Controller

Configure the Istio Ingress Controller and the find the external IP of the istio ingress controller:

```
kubectl apply -f ui-ingress.yaml
kubectl get svc
```

Then you should be able to browse to the IP address to see the hello world UI.  Also  you should be able to curl the hello world ui using http://INGRESS_IP/echo/universe  and the hello world service with http://INGRESS_IP/hello/world



#### [Continue to Exercise 10 - Canary Deployments and Fault Injection](../exercise-10/README.md)
