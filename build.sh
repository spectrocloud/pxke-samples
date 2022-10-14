#!/bin/bash -x

source versions.sh

set -ex
for k8s_version in ${K8S_VERSIONS//,/ }
do 
IMAGE=$IMAGE_REPO:$k8s_version
docker build --build-arg K8S_VERSION=$k8s_version \
             --build-arg BASE_REPO=$BASE_REPO \
             --target ${BUILD_TARGET:-release} \
             -t $IMAGE \
             -f images/Dockerfile.${FLAVOR} ./
done

if [[ "$PUSH_BUILD" == "true" ]]; then
  echo "Pushing image"
  docker push "$IMAGE"
fi

