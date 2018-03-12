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

If you are in an instructor led class with a provided credential, then you don't need to set another project ID.

If you are using you are not using an instructor provided credentials, then you may need to specify a project ID:

```sh
gcloud config set project your-project-id
```

#### Enable Compute Engine and Kubernetes Engine API

```sh
gcloud services enable \
  compute.googleapis.com \
  container.googleapis.com
```

#### Create a Kubernetes Cluster using the Google Kubernetes Engine

Google Kubernetes Engine is Google’s hosted version of Kubernetes.

To create a container cluster execute:

```sh
gcloud container clusters create guestbook \
      --cluster-version=1.9.2-gke.1  \
      --num-nodes 3 \
      --machine-type n1-standard-2
```

#### Verify kubectl
  `kubectl version`

## Explanation
#### By Ray Tsang [@saturnism](https://twitter.com/saturnism)

This will take a few minutes to run. Behind the scenes, it will create Google Compute Engine instances, and configure each instance as a Kubernetes node. These instances don’t include the Kubernetes Master node. In Google Kubernetes Engine, the Kubernetes Master node is managed service so that you don’t have to worry about it!

#### [Continue to Exercise 2 - Deploying a microservice to Kubernetes](../exercise-2/README.md)
