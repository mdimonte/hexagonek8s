# Hands on n°15

The objective is to have a first look at the tool [Helm](https://helm.sh/docs).  
In short, `Helm` is a package manager for Kubernetes, as such it helps you manage (install, upgrade ...) Kubernetes applications.

## instructions

Here are the steps to run in order to install prometheus and grafana based on the Helm chart called `kube-prometheus-stack`:

### pre-requisites

Install the `helm` CLI. See [[here]](https://helm.sh/docs/intro/install/) for detailed instructions

1. add the repository `bitnami` using the `helm` CLI

2. search for the chart `wordpress` in the repo using the `helm` CLI

3. using the `helm` CLI, deploy wordpress from the chart version `32.1.10`

   > make sure to define/override these parameters:
   > - `wordpressUsername`
   > - `wordpressPassword`
   > - `ingress.enabled`
   > - `ingress.hostname`
   > - `ingress.tls`
   > - `ingress.selfSigned`

4. Upgrade wordpress to the latest helm chart version

5. Uninstall wordpress
