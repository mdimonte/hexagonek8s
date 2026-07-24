#!/bin/bash

export RESOURCE_GROUP=hexagone-exam
export CLUSTER_NAME=aks-exam

az aks delete -g $RESOURCE_GROUP -n $CLUSTER_NAME --yes

az group delete -n $RESOURCE_GROUP --yes
