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

If needed you can set a new project id.  Note: For the Scale by the Bay workshop you should already have a project in you google cloud account configured called scalebay17-sfo-5180.

```sh
gcloud config set project scalebay17-sfo-5180
```

#### Create a Kubernetes Cluster using the Google Container Engine.

Google Container Engine is Google’s hosted version of Kubernetes.

To create a container cluster execute:

```sh
gcloud container clusters create guestbook \
      --enable-kubernetes-alpha \
      --num-nodes 4 \
      --scopes cloud-platform \
      --no-enable-legacy-authorization
```



## Explanation
#### By Ray Tsang [@saturnism](https://twitter.com/saturnism)

This will take a few minutes to run. Behind the scenes, it will create Google Compute Engine instances, and configure each instance as a Kubernetes node. These instances don’t include the Kubernetes Master node. In Google Container Engine, the Kubernetes Master node is managed service so that you don’t have to worry about it!

The scopes parameter is important for this lab. Scopes determine what Google Cloud Platform resources these newly created instances can access. By default, instances are able to read from Google Cloud Storage, write metrics to Google Cloud Monitoring, etc. For our lab, we add the cloud-platform scope to give us more privileges, such as writing to Cloud Storage as well.

#### [Continue to Exercise 2 - Deploying a microservice to Kubernetes](../exercise-2/README.md)
