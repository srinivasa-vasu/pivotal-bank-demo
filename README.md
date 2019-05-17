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
2. [Deployment](#Deployment)


# Prerequisites
* Preferably running [PKS](https://docs.pivotal.io/runtimes/pks/1-4/index.html) cluseter or any open K8s based distribution
* git cli in your local machine to clone the repo 
 

# Deployment
* git clone the repo
```
git clone https://github.com/srinivasa-vasu/pivotal-bank-demo.git
```

* git checkout Knative branch
```
cd pivotal-bank-demo && git checkout pks_1.0 && cd k8s/install
```

* run the bach script
```
chmod 755 install.sh && bash install.sh
```

That's it. This will deploy the services.

