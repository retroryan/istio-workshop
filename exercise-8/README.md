## Exercise 8 - Full Install of Istio

#### Start with a clean slate and delete everything from the cluster

  `kubectl delete all --all`

#### Install Istio on the Kubernetes Cluster

1 - First grant cluster admin permissions to the current user (admin permissions are required to create the necessary RBAC rules for Istio):

  `kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$(gcloud config get-value core/account)`

2 - Next install Istio on the Kubernetes cluster:

Change to the Istio directory (istio-0.2.9) and and install istio in the kubernetes cluster

    ```
    cd istio-0.2.9
    kubectl apply -f install/kubernetes/istio.yaml
    ```


#### [Continue to Exercise 9 - Deploying Services with Istio](../exercise-9/README.md)
