## Exercise 2 - Optional
## Peering under the covers of node

`kubectl get pods -owide`

That will list the node the pod is running on. For example you should see:

`NODE gke-guestbook-...`

`gcloud compute ssh <NODE NAME>`

`sudo docker ps`

`someuser@<node-name>:~$ exit`

The Pod name is automatically assigned as the hostname of the container:

```
kubectl exec -ti helloworld-service-v1-... /bin/ash

root@helloworld-...:/data# hostname
helloworld-service-....

root@helloworld-...:/app/src# hostname -i
10.104.1.5

root@helloworld-...:/app/src# exit

root@helloworld-...:/data# hostname -i
10.104.1.5
```

#### [Continue to Exercise 3 - Creating a Kubernetes Service](../exercise-3/README.md)
