#!/bin/bash -x

BASE_REPO=${BASE_REPO:-quay.io/kairos}
K3S_VERSIONS="v1.25.2-k3s1,v1.24.6-k3s1,v1.23.12-k3s1,v1.22.15-k3s1"
RKE2_VERSIONS="v1.24.6-rke2r1,v1.23.12-rke2r1,v1.22.15-rke2r1,v1.25.2-rke2r1"
MICROK8S_VERSIONS="1.25,1.24"
FLAVOR="${FLAVOR:-ubuntu-rke2}"

getK8SVersions() {
	IFS='- ' read -r -a strs <<< "$FLAVOR"
	k8sDistro=${strs[1]}

	case $k8sDistro in
  
         rke2)
	     echo $RKE2_VERSIONS
             ;;

         k3s)
	     echo $K3S_VERSIONS
             ;;
         microk8s)
	     echo $MICROK8S_VERSIONS
             ;;

            *)
             echo -n "unknown"
             ;;
         esac 

}
K8S_VERSIONS=$(getK8SVersions)
