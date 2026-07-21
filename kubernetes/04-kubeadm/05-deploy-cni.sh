#!/bin/bash

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.32.1/manifests/v1_crd_projectcalico_org.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.32.1/manifests/tigera-operator.yaml

curl https://raw.githubusercontent.com/projectcalico/calico/v3.32.1/manifests/custom-resources-bpf.yaml -o - | kubectl apply -f -

printf "check the status of the calico deployment using 'watch kubectl get tigerastatus'\n"
printf "or 'watch kubectl get pods -A'\n\n"
