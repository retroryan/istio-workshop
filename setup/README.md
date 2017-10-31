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
export PATH=$PWD/istoi-0.2.10/bin:$PATH
```

#### Windows Setup

If you install [Git for Windows](https://git-scm.com/downloads) you get Curl automatically too. There are some advantages:

Git takes care of the PATH setup during installation automatically.
You get the GNU bash, a really powerful shell, in my opinion much better than the native Windows console.
You get many other useful Linux tools like tail, cat, grep, gzip, pdftotext, less, sort, tar, vim and even Perl.

#### [Continue to Exercise 1](../exercise-1/README.md)
