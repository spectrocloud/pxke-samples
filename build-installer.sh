#!/bin/bash

set -ex

source .installer.env

ISO="${ISO_IMAGE:-stylus-custom}"

INSTALLER_VERSION="${INSTALLER_VERSION:-v2.0.0-alpha11}"
BASE_IMAGE=gcr.io/spectro-dev-public/stylus-installer:${INSTALLER_VERSION}
IMAGE_NAME="${IMAGE_NAME:-gcr.io/spectro-dev-public/stylus-custom}"
IMAGE="${IMAGE_NAME}:${INSTALLER_VERSION}"
USER_DATA_FILE="${USER_DATA_FILE:-user-data}"
BUILD_PLATFORM="${BUILD_PLATFORM:-linux/amd64}"

if [ ! -z $USER_DATA_FILE ]; then
 mkdir -p overlay/installer/oem
 cp $USER_DATA_FILE overlay/installer/oem/userdata.yaml
fi

if [ ! -z $CONTENT_BUNDLE ]; then
  mkdir -p overlay/files-iso-installer/opt/spectrocloud/content
  cp $CONTENT_BUNDLE overlay/files-iso-installer/opt/spectrocloud/content/
  #zstd -19 -T0 -o overlay/files-iso-installer/opt/spectrocloud/content/spectro-content.tar.zst $CONTENT_BUNDLE
  #rm overlay/files-iso-installer/opt/spectrocloud/content/spectro-content.tar
fi


echo "Building custom $IMAGE from $BASE_IMAGE"
docker build --build-arg BASE_IMAGE=$BASE_IMAGE \
             -t $IMAGE \
             --platform $BUILD_PLATFORM \
             -f images/Dockerfile.installer ./ \
	     --no-cache


echo "Building $ISO.iso from $IMAGE"
docker run -v "$PWD:/cOS" \
           -v /var/run/docker.sock:/var/run/docker.sock \
           -i --rm quay.io/kairos/osbuilder-tools:v0.7.11 build-iso \
             --name $ISO --debug --local  \
             --overlay-iso /cOS/overlay/files-iso-installer --output /cOS/ \
             $IMAGE

