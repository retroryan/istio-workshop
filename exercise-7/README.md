## Exercise 7 - Istio Ingress Controller

The components deployed on the service mesh by default are not exposed outside the cluster. External access to individual services so far has been provided by creating an external load balancer on each service.

A Kubernetes Ingress rule can be created that routes external requests through the Istio Ingress Controller to the backing services.

#### Inspecting the Istio Ingress controller

The ingress controller gets expossed as a normal kubernetes service load balancer:

```sh
kubectl get svc istio-ingress -n istio-system -o yaml
```

Because the Istio Ingress Controller is an Envoy Proxy you can inspect it using the admin routes.  First find the name of the istio ingress proxy:

```sh
kubectl get pods -n istio-system
kubectl port-forward istio-ingress-... -n istio-system 15000:15000
```

If you see a bind error because port `15000` is already used, it's probably the Envoy proxy from previous exercise that's still running locally. Kill the local Envoy proxy:

```sh
docker kill proxy
```

You can view the statistics, listeners, routes, clusters and server info for the envoy proxy by forwarding the local port:

```sh
curl localhost:15000/help
curl localhost:15000/stats
curl localhost:15000/listeners
curl localhost:15000/routes
curl localhost:15000/clusters
curl localhost:15000/server_info
```

See the [admin docs](https://www.envoyproxy.io/docs/envoy/v1.5.0/operations/admin) for more details.

Also it can be helpful to look at the log files of the Istio ingress controller to see what request is being routed.  First find the ingress pod and the output the log files:

```sh
kubectl logs istio-ingress-... -n istio-system
```

#### Configure Guest Book Ingress Routes with the Istio Ingress Controller

1 - Configure the Guess Book UI default route with the Istio Ingress Controller:

First look at what the current route is using the admin interface above.  Then run the following command to change the routes:

```sh
kubectl apply -f guestbook/guestbook-ingress.yaml
```

After applying the routes you can see the routes have changed in the admin interface.

In the guestbook ingress file notice that the ingress class is specified as   `kubernetes.io/ingress.class: istio` which routes the request to Istio.

The second thing to notice is that the request is routed to different services, either helloworld-service or guestbook-ui depending on the request. We can see how this works by having Kubernetes describe the ingress resource for us:

```sh
kubectl describe ingress

Name:             simple-ingress
Namespace:        default
Address:          
Default backend:  default-http-backend:80 (<none>)
Rules:
  Host  Path  Backends
  ----  ----  --------
  *     
        /hello/.*   helloworld-service:8080 (<none>)
        /.*         guestbook-ui:80 (<none>)
Annotations:
Events:  <none>

```

2 - Find the external IP of the Istio Ingress controller and export it to an environment variable:

```sh
kubectl get service istio-ingress -n istio-system -o wide

NAMESPACE      NAME                   CLUSTER-IP      EXTERNAL-IP      PORT(S)                       AGE
istio-system   istio-ingress          10.31.244.185   35.188.171.180   80:31920/TCP,443:32165/TCP    1h
```

Once the Ingress is successfully configured, you can also get the Ingress IP doing:

```sh
kubectl get ingress

NAME             HOSTS     ADDRESS          PORTS     AGE
simple-ingress   *         35.224.145.187   80        2m
```

```sh
export INGRESS_IP=$(kubectl get service istio-ingress -n istio-system --template="{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
```

3 - Browse to the website of the guest Book using the INGRESS IP to see the Guest Book UI: `http://INGRESS_IP`

4 - You can also access the Hello World service and see the json in the browser:
`http://INGRESS_IP/hello/world`


5 - curl the Guest Book Service:
```
curl http://$INGRESS_IP/echo/universe
```

And the Hello World service:
```
curl http://$INGRESS_IP/hello/world
```

6 - Then curl the echo endpoint multiple times and notice how it round robins between v1 and v2 of the Hello World service:

```sh
curl http://$INGRESS_IP/echo/universe

{"greeting":{"hostname":"helloworld-service-v1-286408581-9204h","greeting":"Hello universe from helloworld-service-v1-286408581-9204h with 1.0","version":"1.0"},
```

```sh
curl http://$INGRESS_IP/echo/universe

{"greeting":{"hostname":"helloworld-service-v2-1009285752-n2tpb","greeting":"Hello universe from helloworld-service-v2-1009285752-n2tpb with 2.0","version":"2.0"}
```

#### Inspecting the Istio proxy of the Hello World service pod

To better understand the istio proxy, let's inspect the details.  exec into the hellworld service pod to find the proxy details.  First find the full pod name and then exec into the istio-proxy container:

```sh
kubectl get pods
kubectl exec -it helloworld-service-v1-... -c istio-proxy  sh
```

Once in the container look at some of the envoy proxy details:

```sh
$  ps aux
$  ls -l /etc/istio/proxy
$  cat /etc/istio/proxy/envoy-rev0.json
```

You can also view the statistics, listeners, routes, clusters and server info for the envoy proxy by forwarding the local port:

```sh
kubectl port-forward helloworld-service-v1-... 15000:15000
curl localhost:15000/stats
curl localhost:15000/listeners
curl localhost:15000/routes
curl localhost:15000/clusters
curl localhost:15000/server_info
```

See the [admin docs](https://www.envoyproxy.io/docs/envoy/v1.5.0/operations/admin) for more details.

#### [Exercise 8 - Telemetry](../exercise-8/README.md)
