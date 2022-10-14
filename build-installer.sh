#!/bin/bash

set -ex

source .installer.env

ISO="${ISO_IMAGE:-p6os-custom}"

INSTALLER_VERSION="${INSTALLER_VERSION:-v2.0.0-alpha11}"
BASE_IMAGE=gcr.io/spectro-dev-public/stylus-installer:${INSTALLER_VERSION}
IMAGE_NAME="${IMAGE_NAME:-gcr.io/spectro-dev-public/stylus-custom}"
IMAGE="${IMAGE_NAME}:${INSTALLER_VERSION}"
USER_DATA_FILE="${USER_DATA_FILE:-user-data}"
BUILD_PLATFORM="${BUILD_PLATFORM:-linux/amd64}"

echo "Building custom $IMAGE from $BASE_IMAGE"

if [ -f $USER_DATA_FILE ]; then
 cp $USER_DATA_FILE overlay/installer/oem/userdata.yaml
fi

docker build --build-arg BASE_IMAGE=$BASE_IMAGE \
             -t $IMAGE \
             --platform $BUILD_PLATFORM \
             -f images/Dockerfile.installer ./


echo "Building $ISO.iso from $IMAGE"
docker run -v "$PWD:/cOS" \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -i --rm quay.io/costoolkit/elemental-cli:v0.0.15-8a78e6b build-iso \
             --name $ISO --debug --local  \
             --repo quay.io/costoolkit/releases-teal  \
             --overlay-iso /cOS/overlay/files-iso-installer --output /cOS/ \
             $IMAGE

