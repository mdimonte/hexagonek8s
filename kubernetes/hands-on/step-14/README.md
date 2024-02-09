# Hands on n°14

The objective is to have a first look at the open-source observability stack "prometheus & grafana".

## instructions

Here are the steps to run in order to install prometheus and grafana based on the Helm chart called `kube-prometheus-stack`:

### pre-requisites

Install the `helm` CLI. See [[here]](https://helm.sh/docs/intro/install/) for detailed instructions

1. create a new kubernetes `namespace` called `monitoring`  
   `kubectl create namespace monitoring`

2. install the Helm repository that holds the chart we want to install:

   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
   ```

3. install the Helm chart:
   `helm -n monitoring install kube-prometheus-stack prometheus-community/kube-prometheus-stack`

4. after a while you will notice that kubernetes objects are created in the namespace `monitoring`. Among these objects are the following `services`:
    - `kube-prometheus-stack-grafana`
    - `kube-prometheus-stack-alertmanager`
    - `kube-prometheus-stack-prometheus`  
  Create an `ingress` for each of these `service`.  
  The DNS names targetted by these 3 `ingresses` should be:
    - `grafana.<you_name>.calpeabyla.com`
    - `prometheus.<you_name>.calpeabyla.com`
    - `alertmanager.<you_name>.calpeabyla.com`

5. `prometheus` and `alertmanager` are accessible without authentication: simply access their UI using the DNS names of their `ingresses`.  
`grafana`, however, does require authentication: the default username is `admin` and the default password is `prom-operator`
You should now have everything you need to discover these tools, have fun ;)
