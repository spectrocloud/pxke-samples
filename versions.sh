#!/bin/bash -x

BASE_REPO=${BASE_REPO:-quay.io/kairos}
K3S_VERSIONS="1.25.2-k3s1,1.25.0-k3s1,1.24.6-k3s1,1.24.4-k3s1,1.23.12-k3s1,1.23.10-k3s1,1.22.15-k3s1,1.22.13-k3s1"
RKE2_VERSIONS="v1.24.6-rke2r1,v1.23.12-rke2r1,v1.22.15-rke2r1,v1.25.2-rke2r1"
MICROK8S_VERSIONS="1.25,1.24"
KUBEADM_VERSIONS="1.25.2,1.24.6,1.23.12,1.22.15"
FLAVOR="${FLAVOR:-ubuntu-20-k3s}"
K8SDISTRO=$(echo $FLAVOR | rev | cut -d "-" -f 1 | rev)
getK8SVersions() {

	case $K8SDISTRO in
  
         rke2)
	     echo $RKE2_VERSIONS
             ;;

         k3s)
	     echo $K3S_VERSIONS
             ;;
         microk8s)
	     echo $MICROK8S_VERSIONS
             ;;
         kubeadm)
	     echo $KUBEADM_VERSIONS
	     ;;
            *)
             echo -n "unknown"
             ;;
         esac 

}
K8S_VERSIONS=$(getK8SVersions)
