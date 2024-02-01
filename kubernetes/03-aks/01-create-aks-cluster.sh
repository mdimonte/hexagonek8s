#!/bin/bash

az aks create -g hexagone-kubernetes -n aks-devtest \
   --kubernetes-version v1.27.7 \
   --auto-upgrade-channel patch \
   --dns-service-ip 172.16.0.10 \
   --enable-addons http_application_routing,ingress-appgw \
   --appgw-name my-appgw \
   --appgw-subnet-cidr 10.230.0.0/16 \
   --enable-cluster-autoscaler \
   --max-count 2 \
   --min-count 1 \
   --node-count 1 \
   --k8s-support-plan KubernetesOfficial \
   --load-balancer-sku standard \
   --network-plugin kubenet \
   --network-policy calico \
   --node-vm-size Standard_B2s \
   --os-sku Ubuntu \
   --pod-cidr 192.168.0.0/16 \
   --service-cidr 172.16.0.0/16 \
   --generate-ssh-keys \
   --ssh-key-value $HOME/.ssh/id_mdimonte_hexagone_rsa.pub \
   --tier free

