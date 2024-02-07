#!/bin/bash

az aks upgrade --name aks-devtest \
   --resource-group hexagone-kubernetes-dublin \
   --kubernetes-version 1.28.0 \
   --yes

