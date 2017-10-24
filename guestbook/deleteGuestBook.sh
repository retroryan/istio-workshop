#!/bin/bash

SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

kubectl delete -f $SCRIPTDIR/mysql-pvc.yaml -f $SCRIPTDIR/mysql-deployment.yaml -f $SCRIPTDIR/mysql-service.yaml
kubectl delete -f $SCRIPTDIR/redis-deployment.yaml -f $SCRIPTDIR/redis-service.yaml
kubectl delete -f $SCRIPTDIR/helloworld-deployment.yaml -f $SCRIPTDIR/helloworld-service.yaml
kubectl delete -f $SCRIPTDIR/helloworld-deployment-v2.yaml
kubectl delete -f $SCRIPTDIR/guestbook-deployment.yaml -f $SCRIPTDIR/guestbook-service.yaml
kubectl delete -f $SCRIPTDIR/guestbook-ui-deployment.yaml -f $SCRIPTDIR/guestbook-ui-service.yaml
