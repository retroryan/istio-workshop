## Setup for Creating an Istio Ingress Controller

We are going to create a single Ingress Controller for the entire cluster.  This will eliminate the need for the services to have an external load balancer ip.

#### Remove the Load Balancer from the Hello World Service "Service"

Delete the hello world service so the load balancer is deleted from GCE:

`kubectl delete service helloworld-service`

#### IMPORTANT!! Re-create the  Hello World Service "Service" without a load balancer.

We still need the services to be created.  The version of the [helloworldservice-service.yaml](helloworldservice-service.yaml) in this exercise is almost identical to the previous version of the service, except it doesn't have the type Load Balancer.

`kubectl create -f helloworldservice-service.yaml`

Now when you view the service the EXTERNAL-IP should be none

`kubectl get service`

>NAME                 CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE

>helloworld-service   10.31.240.202   <none>        8080/TCP   28s

>kubernetes           10.31.240.1     <none>        443/TCP    1h

## Download Istio

Only download Istio - do not install it yet!

```
curl -L https://git.io/getIstio | sh -
export PATH=$PWD/istoi-0.1.6/bin:$PATH
```

#### A note on running Istio

Istio related commands have to be done in the Istio directory.  Any Istio related command will use istio$:

`istio$ kubectl apply -f istio-ingress.yaml`

#### [Next - Exercise 6 - Creating the Istio Ingress with the Pilot and Proxy](exercise-6/README.md)
