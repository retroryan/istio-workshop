## Exercise 14 - Ensuring security with iptables

#### A digression

In the last exercise we saw tls enforced. A question that hasn't been answered yet, and possbily hasn't even asked yet: how is it possible for traffic to be passing through the proxy when it hasn't been referenced at all?

#### Enter iptables

iptables is the linux firewall. You may have seen many frontends going by different names but ultimately they manipulate iptables. We are going to take a look at how istio (ab)uses iptables to make proxying traffic seamless.

#### Another digression

Pods mostly don't have root users, this makes taking a look at their network state hard. Fortunately there are ways and means of making them open up to us.

Lets see where our old buddy productpage is scheduled

```
kubectl get  -o template --template '{{ .status.hostIP }}' po $pp
```

That'll give you the internal ip. To ssh onto the box you'll need the external one, you can look that up on the Compute Engine page of the cloud console. You can also click the handy ssh button to get a shell. Until I say otherwise, assume that's the shell we are working with.

```
cid=$(docker ps | grep bookinfo-productpage | awk '{print $1}')
pid=$(docker inspect -f '{{.State.Pid}}' $cid)
```

This gives us the container id of the product page running on the host and its pid. Why are we doing this? Because docker couldn't behave like a good citizen if it's existence depended on it, which clearly it doesn't, because it still exists.

```
sudo mkdir -p /var/run/netns
sudo ln -sf /proc/$pid/ns/net /var/run/netns/pp
```

What did this achieve?

```
sudo ip netns exec pp ss -tln
```

That's right, we just ran a command from the host in the network namespace of a container (this gives us the listening tcp ports).

#### iptables, anyone?

```
sudo ip netns exec pp iptables -t nat -v -L
```

Yields the answer to how the proxy weaves its spell of control

```
Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         
    0     0 ISTIO_REDIRECT  all  --  any    any     anywhere             anywhere             /* istio/install-istio-prerouting */

Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 1222 packets, 114K bytes)
 pkts bytes target     prot opt in     out     source               destination         
   34  2040 ISTIO_OUTPUT  tcp  --  any    any     anywhere             anywhere             /* istio/install-istio-output */

Chain POSTROUTING (policy ACCEPT 1222 packets, 114K bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain ISTIO_OUTPUT (1 references)
 pkts bytes target     prot opt in     out     source               destination         
    0     0 ISTIO_REDIRECT  all  --  any    lo      anywhere            !localhost            /* istio/redirect-implicit-loopback */
   34  2040 RETURN     all  --  any    any     anywhere             anywhere             owner UID match 1337 /* istio/bypass-envoy */
    0     0 RETURN     all  --  any    any     anywhere             localhost            /* istio/bypass-explicit-loopback */
    0     0 ISTIO_REDIRECT  all  --  any    any     anywhere             anywhere             /* istio/redirect-default-outbound */

Chain ISTIO_REDIRECT (3 references)
 pkts bytes target     prot opt in     out     source               destination         
    0     0 REDIRECT   tcp  --  any    any     anywhere             anywhere             /* istio/redirect-to-envoy-port */ redir ports 15001
```

Basically there are a few rules here of interest. A complete explaination is out of the scope of this exercise but here is a summary:

1. In pre-routing we catch the inbound traffic. Anything coming in jumps to our redirect rule.
2. In output we inspect outbound traffic. This is more interesting. Istio runs under uid 1337. To avoid looping, all traffic from this uid is allowed to egress. Traffic outbound not from this uid also jumps to the redirect.
3. The redirect bends all traffic from whatever port it was on to 15001. The observant among you might have noticed that output from the `ss` command we ran earlier.

This effectively forces all traffic to run through the proxy without any cooperation required from the services in the pod.

#### When did that happen?

The init container that istio injects runs a small script to setup this rules with NET\_CAP\_ADMIN. Neat, eh?
