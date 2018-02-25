## Exercise 15 - mTLS again, now with 100% more SPIFFE

Explain spiffe

Revist exfiltrated certs,

```
openssl verify -show_chain -CAfile root-cert.pem cert-chain.pem
```

to show chain and 

```
openssl x509 -in cert-chain.pem -text | less
```

to show the spiffe SAN

talk about the meaning of the url in the context of k8s
