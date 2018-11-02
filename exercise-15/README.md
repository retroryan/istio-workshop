## Exercise 15 - mTLS again, now with 100% more SPIFFE

Istio uses SPIFFE to assert the identify of workloads on the cluster. SPIFFE is a very simple standard. It consists of a notion of identity and a method of proving it. A SPIFFE identity consists of an authority part and a path. The meaning of the path in spiffe land is implementation defined. In k8s it takes the form `/ns/$namespace/sa/$service-account` with the expected meaning. A SPIFFE identify is embedded in a document. This document in principle can take many forms but currently the only defined format is x509. Let's see what an SPIFFE x509 looks like. Remember those certificates we stole earlier? Execute the below snippet either in the directory where you have the certificates locally, if you have `openssl` installed.

```
cd ~/tmp
openssl x509 -in cert-chain.pem -text | less
```

The important thing to notice is that the subject isn't what you'd normally expect. It has no meaning here. What is interesting is the URI SAN (Subject Alternative Name) extension. Note the SPIFFE identify. There is one more part to SPIFFE identity, and that's a signing authority. This a CA certificate with a SPIFFE identify with _no_ path component.

```
openssl verify -show_chain -CAfile root-cert.pem cert-chain.pem
```

You might need to drop the `-show-chain` argument depending on what version of openssl you have installed.  Depending on how long it's been since the certificates were extracted they might be out of date. Istio rolls certificates aggressively.

#### Why?

The Istio proxy uses the SPIFFE identity to establish secure authenticated communication channels over TLS. By providing identities on both the client and server side it establishes mTLS. The service account is also made available as an attribute in mixer.

Interested parties can find the SPIFFE specification https://github.com/spiffe/spiffe. It's very readable. 

#### [Continue to Exercise 16 - Istio RBAC](../exercise-16/README.md)
