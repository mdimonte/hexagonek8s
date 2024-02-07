# Hands on n°11

## Objectives

The objective is to prepare the application to 'resist' cluster maintenance operations with `PodDisruptionBudget`.  
Indeed, when deploying an application on Kubernetes we want it to be highly available.  
As already seen before, resisting failures and high workloads is achieved using `Deployment` with multiple replicas and `HorizontalPodAutoscaler`.  
Now, the objective is that the application keeps running even when the unexpected events are not coming from various failures but maintenance operations executed by the cluster administrators

## deploy the app components

Make a `deployment` manifest to deploy 1 pod (replicas) with the image `mdimonte/single-app:v0.1` and the same characteristics as in the previous exercise, and make a `service` manifest that matches with the deployment, then deploy them on your namespace.  
Next make an `ingress` manifest that dispatches the traffic for the host `step11.<your_name>.calpeabyla.com` to the port `80` of the `service` you have created.

Now try to access the application using the host that you have documented in the ingress in your favorite web browser.

> - in this scenario we use an 'automated' DNS name leveraging the cluster wildcard domain name: `step11.<your_name>.calpeabyla.com`

## deploy an `PodDisruptionBudget`

Now that the application is deployed and is accessible from outside the cluster, let's see how to make sure that it will not become unavailable if the cluster administrators run operations that would bring some part of the cluster down, for example when they upgrade the cluster to a newer version of Kubernetes.  

For that, make a `PodDisruptionBudget` manifest to target the deployment you have just created.  
This `PDB` must set with the attribute `minAvailable` set to `1` and with the `selector.matchLabels` matching the labels set on the pods created by the `Deployment`.  

Here is an example of a `PodDisruptionBudget`:

```yaml
---
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: my-pdb
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app: zookeeper
```

After you have deployed the `PDB`, simulate a maintenance operation ... this can be done by using the command `kubectl drain <node_name>`.  

After you have initiated the maintenance operation, look at the `PDB` (`kubectl get pdb`) and look at the number of the application pods running over time (`kubectl get pods`).  
