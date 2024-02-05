#!/bin/bash

usage() {
  echo "Usage: $0 -k <ssh key filename> -c <control-plane VM name> -w <worker VM name> -o <output kubeconfig file>" 1>&2
  exit 1
}

while getopts "k:c:w:o:" opt; do
    case "${opt}" in
        k)
            ssh_private_keyfile=${OPTARG}
            ;;
        c)
            cp_vm_name=${OPTARG}
            ;;
        w)
            worker_vm_name=${OPTARG}
            ;;
        o)
            kubeconfig=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [[ -z "$ssh_private_keyfile" || -z "$cp_vm_name" || -z "$worker_vm_name" || -z "$kubeconfig" ]]; then
    usage
fi

# getting the private & public IP addresses of the control-plane VM
printf "getting the private IP address of the control-plane VM '%s' ... " $cp_vm_name
nic_id=$(az vm show --resource-group hexagone-kubernetes --name $cp_vm_name | jq -r '.networkProfile.networkInterfaces[0].id')
cp_private_ip_address=$(az network nic show --ids $nic_id | jq -r '.ipConfigurations[0].privateIPAddress')
if [[ $? -eq 0 ]]; then
  printf "ok (%s)\n" $cp_private_ip_address
else
  print "FAILED\n"
  exit 1
fi

printf "getting the public IP address of the control-plane VM '%s' ... " $cp_vm_name
pip_id=$(az network nic show --ids $nic_id | jq -r '.ipConfigurations[0].publicIPAddress.id')
cp_public_ip_address=$(az network public-ip show --ids $pip_id | jq -r '.ipAddress')
if [[ $? -eq 0 ]]; then
  printf "ok (%s)\n" $cp_public_ip_address
else
  print "FAILED\n"
  exit 1
fi

# let's run "kubeadm init ..."
printf "running 'kubeadm init ...' command\n"
ssh -i $ssh_private_keyfile $USER@$cp_public_ip_address 2>/dev/null -- sudo \
    kubeadm init \
        --pod-network-cidr=192.168.0.0/16 \
		    --service-cidr=172.16.0.0/16 \
		    --kubernetes-version=v1.28.2 \
		    --apiserver-advertise-address=$cp_private_ip_address \
		    --control-plane-endpoint=$cp_public_ip_address

printf "getting the kubeadm token that has been generated ... "
token=$(ssh -i $ssh_private_keyfile $USER@$cp_public_ip_address 2>/dev/null -- sudo \
  kubeadm token list | grep -Ev "^TOKEN" | awk '{ print $1 }')
if [[ ! -z "$token" ]]; then
  printf "ok (%s)\n" $token
else
  printf "FAILED\n"
  exit 1
fi

# getting the public IP addresses of the worker-node VM
printf "\ngetting the public IP address of the worker node VM '%s' ... " $worker_vm_name
nic_id=$(az vm show --resource-group hexagone-kubernetes --name $worker_vm_name | jq -r '.networkProfile.networkInterfaces[0].id')
pip_id=$(az network nic show --ids $nic_id | jq -r '.ipConfigurations[0].publicIPAddress.id')
worker_public_ip_address=$(az network public-ip show --ids $pip_id | jq -r '.ipAddress')
if [[ $? -eq 0 ]]; then
  printf "ok (%s)\n" $worker_public_ip_address
else
  print "FAILED\n"
  exit 1
fi

# let's run "kubeadm join ..."
printf "running 'kubeadm join ...' command\n"
ssh -i $ssh_private_keyfile $USER@$worker_public_ip_address 2>/dev/null -- sudo \
    kubeadm join $cp_private_ip_address:6443 \
        --token $token \
		    --discovery-token-unsafe-skip-ca-verification

# display the kubeconfig
printf "creating the kubeconfig file '%s'" $kubeconfig
ssh -i $ssh_private_keyfile $USER@$cp_public_ip_address >$kubeconfig 2>/dev/null -- \
    sudo cat /etc/kubernetes/admin.conf 

