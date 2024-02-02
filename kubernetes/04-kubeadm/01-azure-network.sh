#!/bin/bash

# create the vnet and subnets
printf "Creating the virtual-network ...\n"
az network vnet create --name kubeadm-vnet --resource-group hexagone-kubernetes \
   --tags stage=kubeadm \
   --address-prefixes "10.0.0.0/16"

printf "\nCreating the subnet for the 'control plane nodes' ...\n"
az network vnet subnet create --name control-plane --resource-group hexagone-kubernetes \
   --vnet-name kubeadm-vnet \
   --address-prefixes "10.0.1.0/24"

printf "\nCreating the subnet for the 'worker nodes' ...\n"
az network vnet subnet create --name workers --resource-group hexagone-kubernetes \
   --vnet-name kubeadm-vnet \
   --address-prefixes "10.0.2.0/24"

# create the nsg, populate it and associated it to the subnets
printf "\nCreating the Network Security Group ...\n"
az network nsg create --name kubeadm-nsg --resource-group hexagone-kubernetes \
   --tags stage=kubeadm

printf "\nAdding a rule to allow inbound SSH traffic ...\n"
az network nsg rule create --name allow-inbound-ssh --nsg-name kubeadm-nsg --resource-group hexagone-kubernetes \
   --priority 1000 \
   --access "Allow" \
   --direction "Inbound" \
   --protocol "Tcp" \
   --source-address-prefixes "Internet" \
   --destination-address-prefixes "*" \
   --destination-port-ranges "22"

printf "\nAdding a rule to allow inbound traffic to the Kubernetes API-Server ...\n"
az network nsg rule create --name allow-inbound-apiserver --nsg-name kubeadm-nsg --resource-group hexagone-kubernetes \
   --priority 1001 \
   --access "Allow" \
   --direction "Inbound" \
   --protocol "Tcp" \
   --source-address-prefixes "Internet" \
   --destination-address-prefixes "10.0.1.0/24" \
   --destination-port-ranges "6443"

printf "\nBinding the Network Security Group to the 'control-plane nodes' subnet ...\n"
az network vnet subnet update --name control-plane --resource-group hexagone-kubernetes \
   --vnet-name kubeadm-vnet \
   --nsg kubeadm-nsg

printf "\nBinding the Network Security Group to the 'worker nodes' subnet ...\n"
az network vnet subnet update --name workers --resource-group hexagone-kubernetes \
   --vnet-name kubeadm-vnet \
   --nsg kubeadm-nsg

