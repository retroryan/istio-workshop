`kubectl apply -f helloworldservice-deployment.yaml --record`

`kubectl get pods`

>NAME                           READY     STATUS    RESTARTS   AGE

>helloworld-service-v1-....     1/1       Running   0          20s

Note the name of the pod above for use in the command below

`kubectl delete pod helloworld-service-v1-...`

Kubernetes will automatically restart this pod for you:

`kubectl get pods`

>NAME                           READY     STATUS    RESTARTS   AGE

>helloworld-service-v1-....     1/1       Running   0          20s
