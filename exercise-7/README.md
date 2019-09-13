## Exercise 7 - Istio Ingress Controller

The components deployed on the service mesh by default are not exposed outside the cluster. External access to individual services so far has been provided by creating an external load balancer on each service.

Traditionally in Kubernetes, you would use an Ingress to configure a L7 proxy. However, Istio provides a much richer set of proxy configurations that are not well-defined in Kubernetes Ingress.
Thus, in Istio, we will use Isito Gateway to define fine grained control over L7 edge proxy configuration.

#### Set the Ingress IP for future exercises

Find the IP address of the Ingress Gateway:

```sh
export INGRESS_IP=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo $INGRESS_IP
```

`curl` the IP address:

```sh
curl http://$INGRESS_IP
```

This will return `connection refused` error. That is because there are no gateway configured to listen to any incoming connections.

#### Configure Guestbook Ingress

1 - Create a new Gateway

```sh
kubectl apply -f istio/guestbook-gateway.yaml
```

There is a `selector` block in the gateway definition. The `selector` will be used to find the actual edge proxy that should be configured to accept traffic for the gateway. This example selects pods from any namespaces that has the label of `istio` and value of `ingressgateway`.

This is similar to running:
```sh
kubectl get pods -l istio=ingressgateway --all-namespaces
```

You'll find a single pod that matches this label, which is the Ingress Gateway that we looked at earlier.
```
NAMESPACE      NAME                                    READY     STATUS    RESTARTS   AGE
istio-system   istio-ingressgateway-...                1/1       Running   0          7d
```

After creating the Gateway, it'll enable the Istio Ingress Gateway to listen on port `80`.
The `hosts` block of the configuration can be used to configure virtual hosting. E.g., the same IP address can be configured to respond to different host names with different routing rules.

If you `curl` the ingress IP again:
```sh
curl -v http://$INGRESS_IP
```

Rather than `connection refused`, you should see the server responded with `404 Not Found` HTTP response. This is because we have not bound any backends to this gatway yet.

2 - Create a Virtual Service

To bind a backend to the gateway, we'll need to create a virtual service.

```sh
kubectl apply -f istio/guestbook-ui-vs.yaml
```

A virtual service is a logical grouping of routing rules for a given target service. For ingress, we can use virtual service to bind to a gateway.

This example binds to the gateway we just created, and will respond to any hostname. Again, if you need to use virtual hosting and respond to different host names, you can specify them in the `hosts` section.

3 - Connect via the Ingress Gateway

Try connecting to the Ingress Gateway again.

```sh
curl http://$INGRESS_IP
```

This time you should see the HTTP response!

4 - In a Web Browser navigate to the Guestbook UI using the Ingress Gateway IP address.

5 - Say Hello a few times

#### Optional -Inspecting the Istio Ingress Gateway

The ingress controller gets expossed as a normal Kubernetes service load balancer:

```sh
kubectl get svc istio-ingressgateway -n istio-system -o yaml
```

Because the Istio Ingress Controller is an Envoy Proxy you can inspect it using the admin routes.  First find the name of the istio ingress proxy:


```sh
kubectl port-forward $(kubectl -n istio-system get pod -l app=istio-ingressgateway \
    -o jsonpath='{.items[0].metadata.name}') \
    -n istio-system 8080:15000
```

From the Cloud Shell, use the Web Preview button in the top right corner.

You can view the statistics, listeners, routes, clusters and server info for the envoy proxy by forwarding the local port:

```sh
curl localhost:8080/help
curl localhost:8080/stats
curl localhost:8080/listeners
curl localhost:8080/routes
curl localhost:8080/clusters
curl localhost:8080/server_info
```

See the [admin docs](https://www.envoyproxy.io/docs/envoy/v1.5.0/operations/admin) for more details.

#### Optional - Inspecting the Istio Log Files

It can be helpful to look at the log files of the Istio ingress controller to see what request is being routed.  First find the ingress pod and the output the log files:

```sh
kubectl logs istio-ingressgateway-... -n istio-system
```

#### [Exercise 8 - Telemetry](../exercise-8/README.md)
