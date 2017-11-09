## Exercise 1 - Startup a Kubernetes Cluster

#### Create a gcloud project

It is necessary to create a project in your google cloud account to follow this workshop. You can do it directly in [gcloud console](https://console.cloud.google.com/projectcreate) or executing

```sh
gcloud projects create <YOUR PROJECT ID>
```

Note: For this workshop you should have already created and configured a project in you google cloud account.

#### Set Default Region and Zones

```sh
gcloud config set compute/zone us-central1-f
```
```sh
gcloud config set compute/region us-central1
```

#### Create a Kubernetes Cluster using the Google Container Engine.

Google Container Engine is Google’s hosted version of Kubernetes.

To create a container cluster execute:

```sh
gcloud container clusters create guestbook --num-nodes 4 --scopes cloud-platform --project <YOUR PROJECT ID OPTIONAL>
```

**Note**

If you have multiple gcloud accounts then specify a project id using the --project flag. By default it can be left off. You can get your default project id from the command line with:

```sh
gcloud config get-value core/project
```

Also the project id can be found in the URL of Google Cloud Console. For example if you look in the console it should be something like "https://console.cloud.google.com/kubernetes/list?project=workshopcluster-177619" then the project id is "workshopcluster-177619".

It is recommended to set your <project-id> project as the default one to avoid specifying `--project` flag in all commands. 

```sh
gcloud config set project <YOUR PROJECT ID>
```

## Explanation
#### By Ray Tsang [@saturnism](https://twitter.com/saturnism)

This will take a few minutes to run. Behind the scenes, it will create Google Compute Engine instances, and configure each instance as a Kubernetes node. These instances don’t include the Kubernetes Master node. In Google Container Engine, the Kubernetes Master node is managed service so that you don’t have to worry about it!

The scopes parameter is important for this lab. Scopes determine what Google Cloud Platform resources these newly created instances can access. By default, instances are able to read from Google Cloud Storage, write metrics to Google Cloud Monitoring, etc. For our lab, we add the cloud-platform scope to give us more privileges, such as writing to Cloud Storage as well.

#### [Continue to Exercise 2 - Deploying a microservice to Kubernetes](../exercise-2/README.md)
