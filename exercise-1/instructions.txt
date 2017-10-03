Set Default Region and Zones
  gcloud config set compute/zone us-central1-f
  gcloud config set compute/region us-central1
Create Kubernetes Cluster
  gcloud container clusters create guestbook \
      --num-nodes 4 \
      --scopes cloud-platform \
      --cluster-version "1.7.5" \
      --project <YOUR PROJECT NAME>
