#!/bin/bash

# Script to deploy Azure Cloud-Controller-Manager to kubeadm cluster

set -e

usage() {
  echo "Usage: $0 -s <subscription-id> -t <tenant-id> -g <resource-group>"
  echo "  -s : Azure Subscription ID"
  echo "  -t : Azure Tenant ID"
  echo "  -g : Resource Group name (where VMs are deployed)"
  exit 1
}

while getopts "s:t:g:" opt; do
    case "${opt}" in
        s)
            SUBSCRIPTION_ID=${OPTARG}
            ;;
        t)
            TENANT_ID=${OPTARG}
            ;;
        g)
            RESOURCE_GROUP=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [[ -z "$SUBSCRIPTION_ID" || -z "$TENANT_ID" || -z "$RESOURCE_GROUP" ]]; then
    usage
fi

echo "========================================="
echo "Azure Cloud-Controller-Manager Deployment"
echo "========================================="
echo ""

# Step 1: Create a service principal for CCM
echo "Step 1: Creating Service Principal for Cloud-Controller-Manager..."
SP_NAME="cloud-controller-manager-sp"
SP_OUTPUT=$(az ad sp create-for-rbac --name $SP_NAME --role="Contributor" --scopes="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP" --output json)

CLIENT_ID=$(echo $SP_OUTPUT | jq -r '.appId')
CLIENT_SECRET=$(echo $SP_OUTPUT | jq -r '.password')

echo "  ✓ Service Principal created"
echo "    Client ID: $CLIENT_ID"

# Step 2: Get Azure environment details
echo ""
echo "Step 2: Gathering Azure environment details..."
LOCATION=$(az group show --name $RESOURCE_GROUP --query location -o tsv)
VNET_NAME=$(az network vnet list --resource-group $RESOURCE_GROUP --query "[0].name" -o tsv)
SUBNET_NAME=$(az network vnet subnet list --resource-group $RESOURCE_GROUP --vnet-name $VNET_NAME --query "[0].name" -o tsv)
SECURITY_GROUP_NAME=$(az network nsg list --resource-group $RESOURCE_GROUP --query "[0].name" -o tsv)

echo "  ✓ Location: $LOCATION"
echo "  ✓ VNet: $VNET_NAME"
echo "  ✓ Subnet: $SUBNET_NAME"
echo "  ✓ NSG: $SECURITY_GROUP_NAME"

# Step 3: Create cloud-config file
echo ""
echo "Step 3: Creating cloud-config..."
cat > /tmp/azure.json <<EOF
{
  "cloud": "AzurePublicCloud",
  "tenantId": "$TENANT_ID",
  "subscriptionId": "$SUBSCRIPTION_ID",
  "aadClientId": "$CLIENT_ID",
  "aadClientSecret": "$CLIENT_SECRET",
  "resourceGroup": "$RESOURCE_GROUP",
  "location": "$LOCATION",
  "vmType": "standard",
  "subnetName": "$SUBNET_NAME",
  "securityGroupName": "$SECURITY_GROUP_NAME",
  "vnetName": "$VNET_NAME",
  "vnetResourceGroup": "$RESOURCE_GROUP",
  "routeTableName": "",
  "cloudProviderBackoff": true,
  "cloudProviderBackoffRetries": 6,
  "cloudProviderBackoffDuration": 5,
  "cloudProviderRateLimit": true,
  "cloudProviderRateLimitQPS": 10,
  "cloudProviderRateLimitBucket": 100,
  "useManagedIdentityExtension": false,
  "useInstanceMetadata": true
}
EOF

echo "  ✓ Cloud config created at /tmp/azure.json"

# Step 4: Create Kubernetes secret with Azure credentials
echo ""
echo "Step 4: Creating Kubernetes secret 'azure-cloud-provider'..."
kubectl create secret generic azure-cloud-provider \
  --from-literal=cloud-config="$(cat /tmp/azure.json)" \
  --namespace=kube-system \
  --dry-run=client -o yaml | kubectl apply -f -

echo "  ✓ Secret created"

# Step 5: Download and patch Cloud-Controller-Manager manifest with latest image
echo ""
echo "Step 5: Downloading and patching Azure Cloud-Controller-Manager manifest..."
CCM_VERSION="v1.34.3"  # Latest version available in MCR (mcr.microsoft.com)
curl -sL https://raw.githubusercontent.com/kubernetes-sigs/cloud-provider-azure/master/examples/out-of-tree/cloud-controller-manager.yaml > /tmp/ccm.yaml

# Patch the image version
sed -i "s|mcr.microsoft.com/oss/kubernetes/azure-cloud-controller-manager:v[0-9.]*|mcr.microsoft.com/oss/kubernetes/azure-cloud-controller-manager:${CCM_VERSION}|g" /tmp/ccm.yaml

echo "  ✓ Using image version: ${CCM_VERSION}"

# Deploy the patched manifest
echo "  Deploying Cloud-Controller-Manager..."
kubectl apply -f /tmp/ccm.yaml

echo "  ✓ Cloud-Controller-Manager deployed"

# Step 6: Download and patch Cloud-Node-Manager manifest with latest image
echo ""
echo "Step 6: Downloading and patching Azure Cloud-Node-Manager manifest..."
curl -sL https://raw.githubusercontent.com/kubernetes-sigs/cloud-provider-azure/master/examples/out-of-tree/cloud-node-manager.yaml > /tmp/cnm.yaml

# Patch the image version
sed -i "s|mcr.microsoft.com/oss/kubernetes/azure-cloud-node-manager:v[0-9.]*|mcr.microsoft.com/oss/kubernetes/azure-cloud-node-manager:${CCM_VERSION}|g" /tmp/cnm.yaml

echo "  ✓ Using image version: ${CCM_VERSION}"

# Deploy the patched manifest
echo "  Deploying Cloud-Node-Manager..."
kubectl apply -f /tmp/cnm.yaml

echo "  ✓ Cloud-Node-Manager deployed"

# Step 7: Verify deployment
echo ""
echo "Step 7: Verifying deployment..."
echo "Waiting for pods to be ready..."
sleep 10

kubectl get pods -n kube-system -l component=cloud-controller-manager
kubectl get pods -n kube-system -l component=cloud-node-manager

echo ""
echo "========================================="
echo "Deployment Complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. Verify all pods are running: kubectl get pods -n kube-system"
echo "2. Check CCM logs: kubectl logs -n kube-system -l component=cloud-controller-manager"
echo "3. Check nodes are properly labeled with Azure information"
echo ""
echo "IMPORTANT: Save these credentials securely:"
echo "  Client ID: $CLIENT_ID"
echo "  Client Secret: $CLIENT_SECRET (save this - it won't be shown again)"
echo ""

# Cleanup
rm -f /tmp/azure.json /tmp/ccm.yaml /tmp/cnm.yaml
