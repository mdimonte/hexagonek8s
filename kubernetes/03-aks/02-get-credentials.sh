#!/bin/bash

az aks get-credentials --name aks-devtest \
   --resource-group hexagone-kubernetes \
   --file $HOME/.kube/aks-devtest.config \
   --admin

