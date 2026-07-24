#!/bin/bash

export RESOURCE_GROUP=hexagone-exam
export CLUSTER_NAME=aks-exam
export VM_FLAVOR=Standard_B4als_v2
export NODE_COUNT=4

az provider list --query "[?namespace=='Microsoft.ContainerService']" --output table

az provider register --namespace Microsoft.ContainerService

az group create -n $RESOURCE_GROUP -l swedencentral

az aks create -g $RESOURCE_GROUP -n $CLUSTER_NAME \
   --kubernetes-version v1.35.4 \
   --auto-upgrade-channel patch \
   --api-server-authorized-ip-ranges "$(curl -s ifconfig.me -4)/32,82.65.78.161/32" \
   --dns-name-prefix $CLUSTER_NAME \
   --dns-service-ip 172.16.0.10 \
   --enable-app-routing \
   --node-count $NODE_COUNT \
   --k8s-support-plan KubernetesOfficial \
   --load-balancer-sku standard \
   --max-pods 110 \
   --network-plugin kubenet \
   --network-policy calico \
   --node-vm-size $VM_FLAVOR \
   --os-sku Ubuntu2404 \
   --pod-cidr 192.168.0.0/16 \
   --service-cidr 172.16.0.0/16 \
   --generate-ssh-keys \
   --ssh-key-value $HOME/.ssh/id_mdimonte_hexagone_rsa.pub \
   --sku base \
   --tier free \
   --yes

