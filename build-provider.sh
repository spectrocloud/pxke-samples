#!/bin/bash

set -ex

source .provider.env


PROVIDER_TYPE="${PROVIDER_TYPE:-provider-kubeadm}"
PROVIDER_VERSION="${PROVIDER_VERSION:-1.25.2}"
CORE_IMAGE="${CORE_IMAGE:-quay.io/kairos/core-opensuse-leap:latest}"
PROVIDER_IMAGE_REPOSITORY=${PROVIDER_IMAGE_REPOSITORY:-quay.io/kairos}
BUILD_PLATFORM="${BUILD_PLATFORM:-linux/amd64}"

echo "Cloning workspace custom $IMAGE from $BASE_IMAGE"
git clone https://github.com/kairos-io/$PROVIDER_TYPE
cd $PROVIDER_TYPE
git checkout v1.1.8

echo "Building $PROVIDER_TYPE Provider from $CORE_MAGE"
docker run -t -v $(pwd):/workspace \
              -v /var/run/docker.sock:/var/run/docker.sock \
              -e NO_BUILDKIT=1 \
              earthly/earthly:v0.6.30  \
              +docker-all-platforms \
              --KUBEADM_VERSION=$PROVIDER_VERSION \
              --BASE_IMAGE=$CORE_IMAGE \
              --IMAGE_REPOSITORY=$PROVIDER_IMAGE_REPOSITORY 


