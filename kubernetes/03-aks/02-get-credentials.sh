#!/bin/bash

export RESOURCE_GROUP=hexagone-exam
export CLUSTER_NAME=aks-exam

az aks get-credentials --name $CLUSTER_NAME \
   --resource-group $RESOURCE_GROUP \
   --file $HOME/.kube/$CLUSTER_NAME.config \
   --overwrite-existing \
   --admin

