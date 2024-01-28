#!/bin/bash

# create the VMs for the control-plane
radical=cp
nr=1
i=1
while [[ $i -le $nr ]]; do
  printf "\nCreating the control plane VM #${i} ...\n"
  az vm create --name ${radical}-${nr} --resource-group hexagone-kubernetes \
     --tags stage=kubeadm vm=${radical}-${i} \
     --accept-term \
     --image "Ubuntu2204" \
     --size "Standard_B2s" \
     --authentication-type "ssh" \
     --admin-username "$USER" \
     --ssh-key-name kubeadm-ssh-key \
     --public-ip-address "${radical}-${i}-pip" \
     --public-ip-address-allocation "dynamic" \
     --public-ip-sku "Basic" \
     --vnet-name "kubeadm-vnet" \
     --subnet "control-plane" \
     --nsg "" \
     --storage-sku "Standard_LRS" \
     --os-disk-name "${radical}-${i}-osdisk" \
     --os-disk-size-gb 30 \
     --custom-data cloud-init.yaml
  let i=$i+1
done

# create the VMs for the worker nodes
radical=worker
nr=1
i=1
while [[ $i -le $nr ]]; do
  printf "\nCreating the worker node VM #${i} ...\n"
  az vm create --name ${radical}-${i} --resource-group hexagone-kubernetes \
     --tags stage=kubeadm vm=${radical}-${i} \
     --accept-term \
     --image "Ubuntu2204" \
     --size "Standard_B2s" \
     --authentication-type "ssh" \
     --admin-username "$USER" \
     --ssh-key-name kubeadm-ssh-key \
     --public-ip-address "${radical}-${i}-pip" \
     --public-ip-address-allocation "dynamic" \
     --public-ip-sku "Basic" \
     --vnet-name "kubeadm-vnet" \
     --subnet "workers" \
     --nsg "" \
     --storage-sku "Standard_LRS" \
     --os-disk-name "${radical}-${i}-osdisk" \
     --os-disk-size-gb 30 \
     --custom-data cloud-init.yaml
  let i=$i+1
done
   
