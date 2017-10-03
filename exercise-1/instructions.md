##Exercise 1 - Startup Kubernetes Cluster

#### Set Default Region and Zones

`gcloud config set compute/zone us-central1-f`

`gcloud config set compute/region us-central1`

#### Create Kubernetes Cluster

Your project name can be found in the URL of Google Cloud Console.  For example it should be something like:

https://console.cloud.google.com/kubernetes/list?project=workshopcluster-177619

The project name in that case is workshopcluster-177619

`gcloud container clusters create guestbook \
      --num-nodes 4 \
      --scopes cloud-platform \
      --cluster-version "1.7.5" \
      --project <YOUR PROJECT NAME>`
