## Exercise 1 - Startup a Kubernetes Cluster


#### Set Default Region and Zones

```sh
gcloud config set compute/zone us-central1-f
```
```sh
gcloud config set compute/region us-central1
```

#### Configure your Default Project

If you have multiple gcloud accounts then be sure the correct one is specified for the gcloud. You can get your default project id from the command line with:

```sh
gcloud config get-value core/project
```

If needed you can set a new project id.  Note: For the Scale by the Bay workshop you should already have a project in you Google Cloud account configured called scalebay17-sfo-SOME_NUMBER.  Take note of the `SOME_NUMBER` and use it in the following command.

```sh
gcloud config set project scalebay17-sfo-SOME_NUMBER
```

#### Create a Kubernetes Cluster using the Google Container Engine.

Google Container Engine is Google’s hosted version of Kubernetes.

To create a container cluster execute:

```sh
gcloud container clusters create guestbook \
      --cluster-version=1.9.2-gke.1  \
      --num-nodes 3 \
      --machine-type "n1-standard-2" \
      --scopes cloud-platform
```

#### Verify kubectl
  `kubectl version`

## Explanation
#### By Ray Tsang [@saturnism](https://twitter.com/saturnism)

This will take a few minutes to run. Behind the scenes, it will create Google Compute Engine instances, and configure each instance as a Kubernetes node. These instances don’t include the Kubernetes Master node. In Google Container Engine, the Kubernetes Master node is managed service so that you don’t have to worry about it!

The scopes parameter is important for this lab. Scopes determine what Google Cloud Platform resources these newly created instances can access. By default, instances are able to read from Google Cloud Storage, write metrics to Google Cloud Monitoring, etc. For our lab, we add the cloud-platform scope to give us more privileges, such as writing to Cloud Storage as well.

#### [Continue to Exercise 2 - Deploying a microservice to Kubernetes](../exercise-2/README.md)
