# Hands on n°10

## Objectives

Preparing the application to handle increasing workload properly and dynamically with `HorizontalalPodAutoscaler`

## deploy the app components

Make a `deployment` manifest to deploy 1 pod (replicas) with the image `mdimonte/single-app:v0.1` and the same characteristics as in the previous exercise, and make a `service` manifest that matches with the deployment, then deploy them on your namespace.  
Next make an `ingress` manifest that dispatches the traffic for the host `step10.<your_name>.calpeabyla.com` to the port `80` of the `service` you have created.

Now try to access the application using the host that you have documented in the ingress in your favorite web browser.

> - in this scenario we use an 'automated' DNS name leveraging the cluster wildcard domain name: `step10.<your_name>.calpeabyla.com`

## deploy an `HorizontalPodAutoscaler`

Now that the application is deployed and is accessible from outside the cluster, let's see how to make it able to adjust its 'sizing' according to the amount of CPU it needs to run.  

For that, make a `HorizontalPodAutoscaler` manifest to target the deployment you have just created. This `HPA` must set the minimum number of replicas to 2, the maximum to 5 and add new replica if the CPU average utilization used by the replicas goes beyond 20%.  
Note here, that 20% does not make sense on its own. In order for the system to be able to determine if the CPU consumption goes over a specific percentage, you will have to set what we call `resources` on the container defined in the pod template of the `deployment`.  
Here is an example of such a `resources` definition (do not hesitate to look at the documentation [https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/):  

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  ...
spec:
  template:
    spec:
      ...
      containers:
        - name: XXXX
          ...
          resources:
            limits:
              memory: '150Mi'
              cpu: '200m'
            requests:
              memory: '100Mi'
              cpu: '100m'
```

and here is an example of a `HorizontalPodAutoscaler`:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: test-hap
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: test-deployment
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 50
```

After you have deployed the `HPA`, start generating load on the application.  
You can do this by sendign a lot of http requests to the application (either from your favorite browser or from another POD that you would start and from which you could run multiple `curl` commands targetting the application `service`).  

While you are generating load on the application, look at the `HPA` (`kubectl get hpa`) and look at the number of the application pods running over time (`kubectl get pods`).  
