#!/bin/bash

# create the VMs for the control-plane
radical=cp
nr=1
printf "\nCreating the control plane VM #${nr} ...\n"
az vm create --name ${radical}-${nr} --resource-group hexagone-kubernetes \
   --tags stage=kubeadm vm=${radical}-${nr} \
   --accept-term \
   --image "Ubuntu2204" \
   --size "Standard_B2s" \
   --authentication-type "ssh" \
   --admin-username "$USER" \
   --ssh-key-name kubeadm-ssh-key \
   --public-ip-address "${radical}-${nr}-pip" \
   --public-ip-address-allocation "dynamic" \
   --public-ip-sku "Basic" \
   --vnet-name "kubeadm-vnet" \
   --subnet "control-plane" \
   --nsg "" \
   --storage-sku "Standard_LRS" \
   --os-disk-name "${radical}-${nr}-osdisk" \
   --os-disk-size-gb 30 \
   --custom-data cloud-init.yaml

## REMOVE ME ## # create the VMs for the worker nodes
## REMOVE ME ## radical=worker
## REMOVE ME ## nr=1
## REMOVE ME ## printf "\nCreating the worker node VM #${nr} ...\n"
## REMOVE ME ## az vm create --name ${radical}-${nr} --resource-group hexagone-kubernetes \
## REMOVE ME ##    --tags stage=kubeadm vm=${radical}-${nr} \
## REMOVE ME ##    --accept-term \
## REMOVE ME ##    --image "Ubuntu2204" \
## REMOVE ME ##    --size "Standard_B2s" \
## REMOVE ME ##    --authentication-type "ssh" \
## REMOVE ME ##    --admin-username "$USER" \
## REMOVE ME ##    --ssh-key-name kubeadm-ssh-key \
## REMOVE ME ##    --public-ip-address "${radical}-${nr}-pip" \
## REMOVE ME ##    --public-ip-address-allocation "dynamic" \
## REMOVE ME ##    --public-ip-sku "Basic" \
## REMOVE ME ##    --vnet-name "kubeadm-vnet" \
## REMOVE ME ##    --subnet "workers" \
## REMOVE ME ##    --nsg "" \
## REMOVE ME ##    --storage-sku "Standard_LRS" \
## REMOVE ME ##    --os-disk-name "${radical}-${nr}-osdisk" \
## REMOVE ME ##    --os-disk-size-gb 30 \
## REMOVE ME ##    --custom-data cloud-init.yaml
## REMOVE ME ## 
