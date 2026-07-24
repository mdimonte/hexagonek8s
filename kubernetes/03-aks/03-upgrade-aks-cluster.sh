#!/bin/bash

export RESOURCE_GROUP=hexagone-exam
export CLUSTER_NAME=aks-exam

az aks upgrade --name $CLUSTER_NAME \
   --resource-group $RESOURCE_GROUP \
   --kubernetes-version 1.35.5 \
   --yes

