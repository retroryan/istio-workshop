## Exercise 2 - Deploying a microservice to Kubernetes

#### Deploy hello world service to kubernetes

`kubectl apply -f helloworldservice-deployment.yaml --record`

`kubectl get pods`

>NAME                           READY     STATUS    RESTARTS   AGE

>helloworld-service-v1-....     1/1       Running   0          20s

#### Note the name of the pod above for use in the command below.  Then delete one of the hello world pods.

`kubectl delete pod helloworld-service-v1-...`

#### Kubernetes will automatically restart this pod for you.  Verify it is restarted

`kubectl get pods`

>NAME                           READY     STATUS    RESTARTS   AGE

>helloworld-service-v1-....     1/1       Running   0          20s
