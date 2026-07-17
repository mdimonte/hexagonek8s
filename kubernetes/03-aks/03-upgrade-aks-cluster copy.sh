#!/bin/bash

az aks upgrade --name aks-devtest \
   --resource-group hexagone-kubernetes \
   --kubernetes-version 1.35.5 \
   --yes

