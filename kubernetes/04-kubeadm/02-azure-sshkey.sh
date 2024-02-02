#!/bin/bash

# create the SSH key
printf "Creating the ssh key ...\n"
az sshkey create --name kubeadm-ssh-key --resource-group hexagone-kubernetes \
   --tags stage=kubeadm

