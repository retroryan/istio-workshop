## Istio RBAC

#### Switching it on

```
kubectl apply -f <(istioctl kube-inject -f samples/bookinfo/kube/bookinfo-add-serviceaccount.yaml)
kubectl apply -f samples/bookinfo/kube/istio-rbac-enable.yaml
```


