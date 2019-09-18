## Exercise 13 - Istio Mutual TLS

This has not been tested with Istio 1.2.5!  Auth has changed with recent versions of Istio and this might be out of date!

#### Overview of Istio Mutual TLS

Istio provides transparent, and frankly magical, mutal TLS to services inside the service mesh when asked. By mutual TLS we understand that both the client and the server authenticate each others certificates as part of the TLS handshake.

#### Enable Mutual TLS

Let the past go. Kill it, if you have to:
```
cd ~/istio
kubectl delete all --all
kubectl delete -f install/kubernetes/istio-demo.yaml
```

It's the only way for TLS to be the way it was meant to be:

```
# (from istio install root)
kubectl create -f install/kubernetes/istio-demo-auth.yaml \
  --as=admin \
  --as-group=system:masters
```

We need to (re)create the auto injector. Use the Exercise 6 instructions.

Finally enable injection and deploy the thrilling Book Info sample.

```
# (from istio install root)
kubectl label namespace default istio-injection=enabled
kubectl create -f samples/bookinfo/platform/kube/bookinfo.yaml
kubectl create -f samples/bookinfo/platform/kube/bookinfo-ingress.yaml
```

#### Take it for a spin

At this point it might seem like nothing changed, but it has.
Let's disable the webhook in default for a second.

```
kubectl label namespace default istio-injection-
```

Now lets give ourselves a space to play

```
kubectl run toolbox -l app=toolbox  --image centos:7 /bin/sh -- -c 'sleep 84600'
```

First: let's prove to ourselves that we really are doing something with tls. From here on out assume names like foo-XXXX need to be replaced with the foo podname you have in your cluster. We pass `-k` to `curl` to convince it to be a bit laxer about cert checking.

```
tb=$(kubectl get po -l app=toolbox -o template --template '{{(index .items 0).metadata.name}}')
kubectl exec -it $tb curl -- https://details:9080/details/0 -k
```

Denied!

Let's exfiltrate the certificates out of a proxy so we can pretend to be them (incidentally I hope this serves as a cautionary tale about the importance locking down pods).

```
pp=$(kubectl get po -l app=productpage -o template --template '{{(index .items 0).metadata.name}}')
mkdir ~/tmp # or wherever you want to stash these certs
cd ~/tmp
fs=(key.pem cert-chain.pem root-cert.pem)
for f in ${fs[@]}; do kubectl exec -c istio-proxy $pp /bin/cat -- /etc/certs/$f >$f; done
```

This should give you the certs. Now let us copy them into our toolbox.

```
for f in ${fs[@]}; do kubectl cp $f default/$tb:$f; done
```

Try once more to talk to the details service, but this time with feeling:

```
kubectl exec -it $tb curl -- https://details:9080/details/0 -v --key ./key.pem --cert ./cert-chain.pem --cacert ./root-cert.pem -k
```

Success! We really are protecting our connections with tls. Time to enjoy its magic from the inside. Let's enable the webhook and roll our pod:

```
kubectl label namespace default istio-injection=enabled
kubectl delete po $tb
tb=$(kubectl get po -l app=toolbox -o template --template '{{(index .items 0).metadata.name}}')
kubectl exec -it $tb curl -- http://details:9080/details/0
```

Notice the protocol.

#### [Continue to Exercise 14 - Ensuring security with iptables](../exercise-14/README.md)
