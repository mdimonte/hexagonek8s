# objective

Discovering argoCD: use it to deploy some simple manifests on a Kubernetes cluster.

## Getting started with `argoCD`

Here is the entry point of the `argoCD` documentation: [click-me](https://argo-cd.readthedocs.io/en/stable/)

### rapid install

```bash
# Install argocd
kubectl create namespace argocd
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### using argocd

```bash
# port-forward
kubectl -n argocd port-forward svc/argocd-server 8080:80 8443:443 &

# retrieve the password of the 'admin' user
export ADMIN_PASSWORD=$(kubectl get secret argocd-initial-admin-secret -o jsonpath='{ .data.password }' | base64 -d; echo)
```

with a web browser open http://localhost:8080

- create a 'repo' pointing to `https://github.com/mdimonte/hexagonek8s-argocd-demo.git`
- create an application
- get stuff synchronized onto the cluster

### cleanup

```bash
kubectl delete namespace argocd
```
