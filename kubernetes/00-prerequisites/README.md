# Pre-requisites for kubernetes TP

## kind

1. Have Docker or Podman installed
2. download `kind` from [here](https://github.com/kubernetes-sigs/kind/releases/download/v0.20.0/kind-linux-amd64) for v0.20 on Linux x86_64 architecture or from [here](https://github.com/kubernetes-sigs/kind/releases/) for more options
3. run these commands (see [here](https://kind.sigs.k8s.io/docs/user/quick-start/#installing-from-release-binaries) for detailed installation instructions):

   ```bash
   sudo install --owner root --group root --mode 755 kind-linux-amd64 /usr/local/bin/kind
   ```

4. start using `kind`. See [here](https://kind.sigs.k8s.io/docs/user/quick-start/#creating-a-cluster) to start creating a cluster

## minikube

1. Have Docker installed
2. download `minikube` from [here](https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64) for the latest version on Linux x86_64 architecture or from [here](https://minikube.sigs.k8s.io/docs/start/) for more options
3. run these commands:

   ```bash
   sudo install --owner root --group root --mode 755 minikube-linux-amd64 /usr/local/bin/minikube
   ```

4. start using `minikube` to install a first cluster (see [here](https://minikube.sigs.k8s.io/docs/start/) for details)  
   :fire: make sure to use the option `--driver=docker` when creating your cluster

## aks

1. have an Azure account. You can get a free trial one using these instructions [here](https://azure.microsoft.com/en-us/free/search/?ef_id=_k_CjwKCAiA8NKtBhBtEiwAq5aX2BsBLk0gWTyFDQl8oL8pl7dtHtDI4YWq7opjgeJjtb5tIbAWBdiAsxoCqiEQAvD_BwE_k_&OCID=AIDcmm0g9y8ggq_SEM__k_CjwKCAiA8NKtBhBtEiwAq5aX2BsBLk0gWTyFDQl8oL8pl7dtHtDI4YWq7opjgeJjtb5tIbAWBdiAsxoCqiEQAvD_BwE_k_&gad_source=1&gclid=CjwKCAiA8NKtBhBtEiwAq5aX2BsBLk0gWTyFDQl8oL8pl7dtHtDI4YWq7opjgeJjtb5tIbAWBdiAsxoCqiEQAvD_BwE)
2. go to the [Azure portal](https://portal.azure.com)

   - navigate to `Cost Management + Billing`
   - select `Budget`
   - create a budget, set it to 180$ and set some associated alerts (i.e. 50%, 80%, 95%) to be notified when these thresholds are met

3. install the Azure CLI (`az`) using these instructions [here](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt)
4. login to Azure with the CLI

   ```bash
   az login --use-device-code
   ```

5. try to install an AKS cluster using the CLI

   ```bash
   az aks --help
   az aks create ...
   az aks get-credentials ...
   ```

## kubeadm

1. have an Azure account, the Azure CLI installed and login to Azure using the command `az login --use-device-code`
2. have 2 VMs (ubuntu 22.04) that can connect to each others and to which you can SSH to, from the internet
3. follow the instructions [here](https://v1-28.docs.kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/) to install kubeadm (and its pre-requisites) on the VMs and use it to provision a Kubernetes cluster
