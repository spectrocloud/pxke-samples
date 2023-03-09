#!/bin/bash -x

source versions.sh

set -ex
ISO_IMAGE_NAME="${ISO_IMAGE_NAME:-spectro-installer}"
KAIROS_VERSION="${KAIROS_VERSION:-v1.5.0}"
SPECTRO_VERSION="${SPECTRO_VERSION:-v3.2.2-alpha6}"
INSTALLER_IMAGE_NAME="${IMAGE_NAME:-gcr.io/spectro-dev-public/spectro-edge-installer}"
INSTALLER_IMAGE="${INSTALLER_IMAGE_NAME}:${SPECTRO_VERSION}"
USER_DATA_FILE="${USER_DATA_FILE:-user-data}"
BUILD_PLATFORM="${BUILD_PLATFORM:-linux/amd64}"

echo "Building custom $IMAGE from $BASE_IMAGE"

if [ -f $USER_DATA_FILE ]; then
 cp $USER_DATA_FILE overlay/files-iso/config.yaml
fi
DOCKERFILE=Dockerfile.${FLAVOR}
BASE_IMAGE_ARG="BASE_IMAGE_TAG=$KAIROS_VERSION"
if [ ! -z $BASE_IMAGE ]; then
DOCKERFILE=Dockerfile.byos-${K8SDISTRO}
BASE_IMAGE_ARG="BASE_IMAGE=$BASE_IMAGE"
fi
docker build  --build-arg SPECTRO_VERSION=$SPECTRO_VERSION \
              --build-arg $BASE_IMAGE_ARG \
               -t $INSTALLER_IMAGE -f images/$DOCKERFILE .


echo "Building $ISO.iso from $IMAGE"
docker run -v $PWD:/cOS \
            -v /var/run/docker.sock:/var/run/docker.sock \
             -i --rm quay.io/kairos/osbuilder-tools:v0.3.3 --name $ISO_IMAGE_NAME \
             --debug build-iso --date=false $INSTALLER_IMAGE  --local --overlay-iso /cOS/overlay/files-iso  --output /cOS/


for k8s_version in ${K8S_VERSIONS//,/ }
do 
IMAGE=$IMAGE_REPO:$k8s_version
docker build --build-arg K8S_VERSION=$k8s_version \
             --build-arg $BASE_IMAGE_ARG \
             --build-arg SPECTRO_VERSION=$SPECTRO_VERSION \
             -t $IMAGE \
             -f images/$DOCKERFILE ./
done

if [[ "$PUSH_BUILD" == "true" ]]; then
  echo "Pushing image"
  docker push "$IMAGE"
fi
rm -rf  overlay/files-iso/config.yaml
