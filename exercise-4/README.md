## Exercise 4 - Scaling In and Out

#### Scale the number of Hello World Service “pods

Scaling the number of replicas of our Hello World service is as simple as running :

`kubectl get deployment`

`kubectl scale deployment helloworld-service-v1 --replicas=4`

`kubectl get deployment`

`kubectl get pods`

Scale out even more

`kubectl scale deployment helloworld-service-v1 --replicas=12`

If you look at the pod status some of the Pods will show a `Pending` state.   That is because we only have four physical nodes, and the underlying infrastructure has run out of capacity to run the containers with the requested resources.

Pick a Pod name that is associated with the Pending state to confirm the lack of resources in the detailed status:

`kubectl describe pod helloworld-service...`

We can easily spin up another Compute Engine instance to append to the cluster.

`gcloud container clusters resize guestbook --size=5`

`gcloud compute instances list`

Verify the new instance has joined the Kubernetes cluster, you’ll should be able to see it with this command:

`kubectl get nodes`

`kubectl scale deployment helloworld-service --replicas=4`

#### [Continue to Exercise 5 - Setup for Creating an Istio Ingress Controller](../exercise-5/README.md)
