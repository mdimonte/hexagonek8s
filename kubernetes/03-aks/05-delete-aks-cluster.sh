#!/bin/bash

az aks delete -g hexagone-kubernetes -n aks-devtest --yes

az group delete -n hexagone-kubernetes --yes
