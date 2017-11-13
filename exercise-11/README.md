## Exercise 11 - Security

Based on the following which does not work:

https://istio.io/docs/tasks/security/mutual-tls.html

```
  kubectl exec -it $(kubectl get pod -l app=guestbook-ui \
    -o jsonpath='{.items[0].metadata.name}') \
    -c istio-proxy /bin/bash
```

Does not work because istio-proxy container does not have curl!!!

```
  curl https://helloworld-service:8080/hello/sanfrancisco -v --key /etc/certs/key.pem --cert /etc/certs/cert-chain.pem --cacert /etc/certs/root-cert.pem -k
```

Copy certs to local directory and use for curl:

```
  mkdir certs
  cd certs
  kubectl cp guestbook-ui-1872113123-p2st1:/etc/certs . -c istio-proxy
  curl https://35.202.108.95 -v --key key.pem --cert cert-chain.pem --cacert root-cert.pem -k
```
