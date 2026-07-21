#!/bin/bash

az provider list --query "[?namespace=='Microsoft.ContainerService']" --output table

az provider register --namespace Microsoft.ContainerService

az group create -n hexagone-kubernetes -l swedencentral

az aks create -g hexagone-kubernetes -n aks-devtest \
   --kubernetes-version v1.35.4 \
   --auto-upgrade-channel patch \
   --api-server-authorized-ip-ranges "$(curl -s ifconfig.me)" \
   --dns-name-prefix aks-devtest \
   --dns-service-ip 172.16.0.10 \
   --enable-app-routing \
   --node-count 2 \
   --k8s-support-plan KubernetesOfficial \
   --load-balancer-sku standard \
   --max-pods 110 \
   --network-plugin kubenet \
   --network-policy calico \
   --node-vm-size Standard_D4ps_v6 \
   --os-sku Ubuntu2404 \
   --pod-cidr 192.168.0.0/16 \
   --service-cidr 172.16.0.0/16 \
   --generate-ssh-keys \
   --ssh-key-value $HOME/.ssh/id_mdimonte_hexagone_rsa.pub \
   --sku base \
   --tier free \
   --yes

