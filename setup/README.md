## Workshop Setup

#### Setup [CLOUD SDK](https://cloud.google.com/sdk/)

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

#### Verify kubectl
  `kubectl version`

#### Get the Workshop Source:

  `git clone https://github.com/retroryan/istio-workshop`


#### Download Istio

Only download Istio - do not install it yet!

Either download it directly or get the latest:

https://github.com/istio/istio/releases

```
curl -L https://git.io/getLatestIstio | sh -
export PATH=$PWD/istoi-0.1.6/bin:$PATH
```

#### [Continue to Exercise 1](../exercise-1/README.md)
