# Pivotal Bank Demo App

This demo app is a microservice version of the Spring Trader application. It details the steps to install these services to PKS (infact any K8s based distribution) making use of Knative and Istio. It is still a WIP, but most of the services were tested in PKS. 

>This repository was logically forked from the original [Pivotal-Bank](https://github.com/pivotal-bank) and collapsed
into a mono-repo for ease of rapid development by single demo-er.  Additional changes have been 
made to the repo that further strayed from the original to address demo needs.  In time, these changes
will be considered for inclusion in the origin pivotal-bank source.

![Spring Trader](/docs/springtrader2.png)

# Introduction

This repository holds a collection of micro services that work together to present a trading application surfaced though a web UI, but more interfaces can be created that re-utilise the microservices.

It was created to support workshops and demonstrations of building and using `microservices` architectures and running these in **Cloud Foundry** (although it is possible to run these on other runtimes).

The workshops follow a series of exercises, or labs, and you can find links to the guides for these exercises [below](#workshops).

## Table of Contents

1. [Prerequisites](#Prerequisites)
2. [Initialization](#Initialization)
3. [Deployment](#Deployment)


# Prerequisites
* Preferably running K8s cluster provisioned through [PKS](https://docs.pivotal.io/runtimes/pks/1-7/index.html) or any open K8s based distribution
* git cli in your local machine to access and clone the repo 
 

# Initialization
* git clone the repo
```
git clone https://github.com/srinivasa-vasu/pivotal-bank-demo.git
```

* git checkout Knative branch
```
cd pivotal-bank-demo && git checkout observability_1.0
```

* update <to_be_filled> fields in [config](https://github.com/srinivasa-vasu/pivotal-bank-demo/blob/observability_1.0/k8s/deploy/config-props.yaml) 

* update tag policy in [skaffold.yaml](https://github.com/srinivasa-vasu/pivotal-bank-demo/blob/observability_1.0/k8s/skaffold.yaml) to point to your repo and appropriately update the k8s manifests in [deploy](https://github.com/srinivasa-vasu/pivotal-bank-demo/tree/observability_1.0/k8s/deploy) folder as well

* create a k8s `secret` file named `harbor-registry` in [deploy](https://github.com/srinivasa-vasu/pivotal-bank-demo/tree/observability_1.0/k8s/deploy) with whereabouts of the container registry. This will be used by the [serviceaccount](https://github.com/srinivasa-vasu/pivotal-bank-demo/blob/observability_1.0/k8s/deploy/sa.yaml) to pull images from that registry.

# Deployment
* run the following command to build, deploy and continuously iterate on
```
skaffold dev
```

That's it. This will deploy the services.


