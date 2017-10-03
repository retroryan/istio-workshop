## Creating the Istio Pilot and Proxy

#### Create the necessary cluster roles

`kubectl create clusterrolebinding cluster-admin-binding \
    --clusterrole=cluster-admin \
    --user=$(gcloud config get-value core/account)`


#### Deploy Istio Pilot

`kubectl apply -f istio-pilot.yaml`

#### Deploy Istio Proxy

`kubectl apply -f istio-pilot.yaml`

#### Verify the Pilot and Proxy are deployed

The list of pods should show istio-pilot and istio-proxy running:

`kubectl get pods`
