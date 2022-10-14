#!/bin/bash

set -o allexport
source .local.env
set +o allexport

bash build.sh

# # openSUSE
# REVISION=3 \
# ISO=p6os-1.21.12-3 \
# K8S_VERSION=v1.21.12 \
# FLAVOR=opensuse bash build.sh

# ubuntu-cncf
# REVISION=3 \
# ISO=p6os-ubuntu-1.21.12-3 \
# K8S_VERSION=v1.21.12 \
# FLAVOR=ubuntu-cncf bash build.sh

# openSUSE-rpi
# REVISION=3 \
# ISO=p6os-1.21.12-3 \
# K8S_VERSION=v1.21.12 \
# FLAVOR=opensuse-arm-rpi bash build.sh

#SC_IMAGE=gcr.io/spectro-images-public/saamalik/p6os:opensuse-v1.21.12-2

# REVISION=1 ISO=p6os-1.22.9 K8S_VERSION=v1.22.9 FLAVOR=opensuse IMAGE=gcr.io/spectro-images-public/saamalik/p6os:opensuse-v1.22.9-1 bash build.sh

# ubuntu
#REVISION=1 ISO=p6os-1.21.12-ubuntu K8S_VERSION=v1.21.12 FLAVOR=ubuntu-k3s IMAGE=gcr.io/spectro-images-public/saamalik/p6os:ubuntu-k3s-v1.21.12-1 bash build.sh

# REVISION=1 ISO=p6os-1.21.12-ubuntu-new K8S_VERSION=v1.21.12 FLAVOR=ubuntu-k3s IMAGE=quay.io/costoolkit/releases-orange:cos-system-0.8.10-1 bash build.sh
# REVISION=1 ISO=p6os-1.21.12-ubuntu K8S_VERSION=v1.21.12 FLAVOR=ubuntu-k3s IMAGE=gcr.io/spectro-images-public/saamalik/p6os:ubuntu-k3s-v1.21.12-1 bash build.sh
# REVISION=1 ISO=p6os-1.22.9-ubuntu K8S_VERSION=v1.22.9 FLAVOR=opensuse IMAGE=gcr.io/spectro-images-public/saamalik/p6os:opensuse-v1.22.9-1 bash build.sh

# REVISION=0 ISO=p6os-1.21.12 K8S_VERSION=1.21.12 FLAVOR=opensuse IMAGE=gcr.io/spectro-images-public/saamalik/p6os:opensuse-v1.21.12-0 bash build.sh
# ISO=p6os-1.22.9 FLAVOR=opensuse IMAGE=gcr.io/spectro-images-public/saamalik/p6os:opensuse-v1.22.9-0 bash build.sh
# ISO=p6os-1.23.6 FLAVOR=opensuse IMAGE=gcr.io/spectro-images-public/saamalik/p6os:opensuse-v1.23.6-0 bash build.sh

# docker build -t builder --target builder-golang . -f Dockerfile.opensuse
# docker cp $(docker create builder:latest sh):/work/cli/p6os p6os
# scp -P ${1:-2223} p6os p6os@localhost:
