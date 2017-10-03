## Exercise 2 - Deploying a microservice to Kubernetes

#### Deploy hello world service to kubernetes

`kubectl apply -f helloworldservice-deployment.yaml --record`

`kubectl get pods`

>NAME                           READY     STATUS    RESTARTS    AGE

>helloworld-service-v1-....     1/1       Running   0           20s

#### Note the name of the pod above for use in the command below.  Then delete one of the hello world pods.

`kubectl delete pod helloworld-service-v1-...`

#### Kubernetes will automatically restart this pod for you.  Verify it is restarted

`kubectl get pods`

>NAME                           READY     STATUS    RESTARTS   AGE

>helloworld-service-v1-....     1/1       Running   0          20s

#### All of the container output to STDOUT and STDERR will be accessible as Kubernetes logs:

`kubectl logs helloworld-service-v1-...`

`kubectl logs -f helloworld-service-v1-...``

## Exercise 2 - Details
#### By Ray Tsang [@saturnism](https://twitter.com/saturnism)

We will be using yaml files throughout this workshop.  Every file describes a resource that needs to be deployed into Kubernetes. We won’t be able to go into details on the contents, but you are definitely encouraged to read them and see how pods, services, and others are declared.

The pod deploys a microservice that is a container whose images contains a self-executing JAR files. The source is available at [istio-by-example-java](https://github.com/saturnism/istio-by-example-java) if you are interested in seeing it.

In this first example we deployed a Kubernetes pod by specifying a deployment using this [helloworldservice-deployment.yaml](helloworldservice-deployment.yaml).  

A Kubernetes pod is a group of containers, tied together for the purposes of administration and networking. It can contain one or more containers.  All containers within a single pod will share the same networking interface, IP address, volumes, etc.  All containers within the same pod instance will live and die together.  It’s especially useful when you have, for example, a container that runs the application, and another container that periodically polls logs/metrics from the application container.

You can start a single Pod in Kubernetes by creating a Pod resource. However, a Pod created this way would be known as a Naked Pod. If a Naked Pod dies/exits, it will not be restarted by Kubernetes. A better way to start a pod, is by using a higher-level construct such as Replication Controller, Replica Set, or a Deployment.

Prior to Kubernetes 1.2, Replication Controller is the preferred way deploy and manage your application instances. Kubernetes 1.2 introduced two new concepts - Replica Set, and Deployments.

Replica Set is the next-generation Replication Controller. The only difference between a Replica Set and a Replication Controller right now is the selector support. Replica Set supports the new set-based selector requirements whereas a Replication Controller only supports equality-based selector requirements.

For example, Replication Controller can only select pods based on equality, such as "environment = prod", whereas Replica Sets can select using the "in" operator, such as "environment in (prod, qa)". Learn more about the different selectors in the [Labels guide](http://kubernetes.io/docs/user-guide/labels).

Deployment provides declarative updates for Pods and Replica Sets. You only need to describe the desired state in a Deployment object, and the Deployment controller will change the actual state to the desired state at a controlled rate for you. You can use deployments to easily:
- Create a Deployment to bring up a Replica Set and Pods.
- Check the status of a Deployment to see if it succeeds or not.
- Later, update that Deployment to recreate the Pods (for example, to use a new image, or configuration).
- Rollback to an earlier Deployment revision if the current Deployment isn’t stable.
- Pause and resume a Deployment.

In this workshop, because we are working with Kubernetes 1.7+, we will be using Deployment extensively.

There are other containers running too. The interesting one is the pause container. The atomic unit Kubernetes can manage is actually a Pod, not a container. A Pod can be composed of multiple tightly-coupled containers that is guaranteed to scheduled onto the same node, and will share the same Pod IP address, and can mount the same volumes.. What that essentially means is that if you run multiple containers in the same Pod, they will share the same namespaces.

A pause container is how Kubernetes uses Docker containers to create shared namespaces so that the actual application containers within the same Pod can share resources.
