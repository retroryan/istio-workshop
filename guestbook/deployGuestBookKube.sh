#!/bin/bash

SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

kubectl apply -f $SCRIPTDIR/mysql-pvc.yaml  -f $SCRIPTDIR/mysql-deployment.yaml -f $SCRIPTDIR/mysql-service.yaml
kubectl apply -f $SCRIPTDIR/redis-deployment.yaml -f $SCRIPTDIR/redis-service.yaml
kubectl apply -f $SCRIPTDIR/helloworld-deployment.yaml -f $SCRIPTDIR/helloworld-service.yaml
kubectl apply -f $SCRIPTDIR/helloworld-deployment-v2.yaml
echo "Waiting for mysql and redis startup before starting guestbook"
sleep 120
kubectl apply -f $SCRIPTDIR/guestbook-deployment.yaml -f $SCRIPTDIR/guestbook-service.yaml
sleep 120
echo "Waiting for guestbook startup before starting UI"
kubectl apply -f $SCRIPTDIR/guestbook-ui-deployment.yaml -f $SCRIPTDIR/guestbook-ui-service.yaml
