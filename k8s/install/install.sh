#!/usr/bin/env bash

echo "Enter your registry username: "
read -s REG_USER
echo "Enter your registry password: "
read -s REG_PASS
read -p "Enter your registry repo name: "  REGISTRY
read -p "Enter your namespace: "  NAMESPACE
#read -p "Enter your external domain name: "  DOMAIN

if [[ -z ${REG_USER} ]] || [[ -z ${REG_PASS} ]] || [[ -z ${REGISTRY} ]] || [[ -z ${NAMESPACE} ]]
then
    echo "Can't proceed without the inputs"
    exit 1;
else
    echo "Given inputs will not be validated; If the inputs are invalid, then most likely deployment will fail"
fi

VERSION=v0.4.0

# Install knative and istio
echo "Installing Knative and Istio manifests - $VERSION: "

kubectl apply --filename https://github.com/knative/serving/releases/download/$VERSION/serving.yaml \
--filename https://github.com/knative/build/releases/download/$VERSION/build.yaml \
--filename https://github.com/knative/eventing/releases/download/$VERSION/release.yaml \
--filename https://github.com/knative/eventing-sources/releases/download/$VERSION/release.yaml \
--filename https://github.com/knative/serving/releases/download/$VERSION/monitoring.yaml \
--filename https://raw.githubusercontent.com/knative/serving/$VERSION/third_party/config/build/clusterrole.yaml

echo "Creating namespace - $NAMESPACE:"
kubectl create ns ${NAMESPACE}

# Allow egress from pods
echo "Patching egress for traffic from pod, service n/w to outside world: "
kubectl patch cm config-network -p '{"data": {"clusteringress.class": "istio.ingress.networking.knative.dev", "istio.sidecar.includeOutboundIPRanges": "10.200.0.0/16,10.100.200.0/24"}}' -n knative-serving


# Install jib buildtemplate
echo "Installing jib-gradle build template: "
kubectl apply -f https://raw.githubusercontent.com/knative/build-templates/master/jib/jib-gradle.yaml -n $NAMESPACE

#install DB service
pushd $(dirname $PWD)/service
echo "Configuring trader-db container: "
kubectl apply -f trader-db.yaml -n $NAMESPACE
popd

# install knative app files
pushd $(dirname $PWD)/knative

envsubst < ./secret-tbu.yaml | kubectl -n $NAMESPACE apply -f -
echo "Deploying Pivotal Bank app services using Knative: "
kubectl apply -f sa.yaml -n $NAMESPACE
envsubst < ./config-service.yaml | kubectl -n $NAMESPACE apply -f -
envsubst < ./quotes-service.yaml | kubectl -n $NAMESPACE apply -f -
envsubst < ./portfolio-service.yaml | kubectl -n $NAMESPACE apply -f -
envsubst < ./accounts-service.yaml | kubectl -n $NAMESPACE apply -f -
envsubst < ./user-service.yaml | kubectl -n $NAMESPACE apply -f -
envsubst < ./web-service.yaml | kubectl -n $NAMESPACE apply -f -
popd


# install knative app files
pushd $(dirname $PWD)/istio
echo "Configuring Istio traffic rules: "
kubectl apply -f config-service.yaml -n $NAMESPACE
kubectl apply -f quotes-service.yaml -n $NAMESPACE
kubectl apply -f portfolio-service.yaml -n $NAMESPACE
kubectl apply -f accounts-service.yaml -n $NAMESPACE
kubectl apply -f user-service.yaml -n $NAMESPACE
kubectl apply -f web-service.yaml -n $NAMESPACE
popd
