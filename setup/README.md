## Workshop Setup

###  Google Cloud Console Setup

Login to Google Cloud Console with the special workshop credentials:

[https://console.cloud.google.com/home](https://console.cloud.google.com/home)

If you were provided with a Google Cloud Lab username setup the account by:

1 - Dismiss the offer for a free trial and select the project

![Google Cloud Console Setup](../images/homescreen.png)

2 - Select the ScaleBay SFO [SOME_NUMBER] project:

![Google Cloud Console Setup 2](../images/homescreen2.png)

### Google Cloud

You must set your default compute service account to include:

* `roles/container.admin (Kubernetes Engine Admin)`
* `Editor (on by default)`

To set this, navigate to the IAM section of the Cloud Console and find your default GCE/GKE service account in the following form: projectNumber-compute@developer.gserviceaccount.com: by default it should just have the Editor role. Then in the Roles drop-down list for that account, find the Kubernetes Engine group and select the role Kubernetes Engine Admin. The Roles listing for your account will change to Multiple.

##  Google Cloud Shell or Local Install

This workshop can either be run all locally using the following setup instructions or it can be run in Google Cloud Shell.

### Local Setup [CLOUD SDK](https://cloud.google.com/sdk/)

####  Install Cloud SDK

  `./google-cloud-sdk/install.sh`

#### Initialize Cloud SDK

  `./google-cloud-sdk/bin/gcloud init`

#### Login to Cloud

  `gcloud auth login`

#### Verify Cloud SDK

  `gcloud config list`

#### Install kubectl

  `gcloud components install kubectl`

If you already have an installation of kubectl in your computer you can skip this step.

## Get the Workshop Source:

  `git clone https://github.com/retroryan/istio-workshop`


## Download Istio

Only download Istio - do not install it yet!

Either download it directly or get the latest:

https://github.com/istio/istio/releases

```
curl -L https://git.io/getLatestIstio | sh -
export PATH=$PWD/istio-0.2.12/bin:$PATH
```

#### Windows Setup

If you install [Git for Windows](https://git-scm.com/downloads) you get Curl automatically too. There are some advantages:

Git takes care of the PATH setup during installation automatically.
You get the GNU bash, a really powerful shell, in my opinion much better than the native Windows console.
You get many other useful Linux tools like tail, cat, grep, gzip, pdftotext, less, sort, tar, vim and even Perl.

#### [Continue to Exercise 1](../exercise-1/README.md)
