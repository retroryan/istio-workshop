## Exercise 1 - Startup a Kubernetes Cluster


#### Optional - Set the default region and zones

If you did not set the default region and zones in the setup, configure them now.

Note: For the lab, use the region/zone recommended by the instructor. Learn more about different zones and regions in [Regions & Zones documentation](https://cloud.google.com/compute/docs/zones).


```sh
gcloud config set compute/zone us-central1-c
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

If you are not using an instructor provided credentials, then you may need to specify a project ID:

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
      --cluster-version=1.10 \
      --num-nodes 3 \
      --machine-type n1-standard-2 \
      --scopes cloud-platform
```

Warning: The scopes parameter is important for this lab. Scopes determine what Google Cloud Platform resources these newly created instances can access.  By default, instances are able to read from Google Cloud Storage, write metrics to Google Cloud Monitoring, etc. For our lab, we add the cloud-platform scope to give us more privileges, such as writing to Cloud Storage as well.


#### Verify kubectl
  `kubectl version`

## Explanation
#### By Ray Tsang [@saturnism](https://twitter.com/saturnism)

This will take a few minutes to run. Behind the scenes, it will create Google Compute Engine instances, and configure each instance as a Kubernetes node. These instances don’t include the Kubernetes Master node. In Google Kubernetes Engine, the Kubernetes Master node is managed service so that you don’t have to worry about it!

#### [Continue to Exercise 2 - Deploying a microservice to Kubernetes](../exercise-2/README.md)
