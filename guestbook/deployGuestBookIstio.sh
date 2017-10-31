kubectl apply -f guestbook/mysql-pvc.yaml -f <(istioctl kube-inject -f guestbook/mysql-deployment.yaml) -f guestbook/mysql-service.yaml
kubectl apply -f <(istioctl kube-inject -f guestbook/redis-deployment.yaml) -f guestbook/redis-service.yaml
kubectl apply -f <(istioctl kube-inject -f guestbook/helloworld-deployment.yaml) -f guestbook/helloworld-service.yaml
kubectl apply -f <(istioctl kube-inject -f guestbook/helloworld-deployment-v2.yaml)

### Wait for mysql and redis startup before starting guestbook !!!!

kubectl apply -f <(istioctl kube-inject -f guestbook/guestbook-deployment.yaml) -f guestbook/guestbook-service.yaml

### Wait for guestbook service startup before starting Guest Book UI"


kubectl apply -f <(istioctl kube-inject -f guestbook/guestbook-ui-deployment.yaml) -f guestbook/guestbook-ui-service.yaml
