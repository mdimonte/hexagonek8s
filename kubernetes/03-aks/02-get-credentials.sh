#!/bin/bash

az aks get-credentials --name aks-devtest \
   --resource-group hexagone-kubernetes-dublin \
   --file $HOME/.kube/aks-devtest.config \
   --overwrite-existing \
   --admin

