# Hands on n°6

## Objectives

Deploy a more realistic app made up of 2 services/components:

- a SpringBoot backend-end service
- an Angular front-end service to access the backend

## steps to run

### deploy the app component

First, we will deploy the backend. We want to deploy a `deployment` with this caracteristics:

- 1 replica
- one container using the image `mdimonte/backend-singleapp:v0.1`
- the `http` port being the port `8080` of the container
- 30m CPU and 512Mi of memory as requests
- 300m CPU and 750Mi of memory as limits
- the label `app: backend`

Then create a `service` of type `ClusterIP` matching pods of the `deployment` and routing the traffic from its port `80` to the port `http` of the backing pods.  
Third, create an `ingress` listening on the host `step6-backend.<your_name>.calpeabyla.com` and dispatching the inbound traffic to the port `80` of service you have create in the previous step.

Once the manifests are ready, deploy them on the cluster.

If the backend is running and reachable, it is time to deploy the frontend component.

We want a second `service` of type `ClusterIP` matching the pods with the label `app: frontend` and routing the traffic from its port `80` to the port `http` of the pods.  
And we also need a second `ingress` listening on the host `step6.<your_name>.calpeabyla.com` and dispatching the inbound traffic to the port `80` of service you have created just above.  

We would also like to be able to change the configuration of the frontend, especially the URL making reference to the backend component, without having to change the Docker image. To do this, we can use a [`configMap`](https://kubernetes.io/docs/concepts/configuration/configmap/). Let's write a manifest for this `configmap` and in the attribute `data` put a *file-like* key `config.json` with the following content:

```json
{
    "BACKEND_URL": "http://step6-backend.<your_name>.calpeabyla.com"
}
```

Then write the `deployment` manifest for the frontend that will use this `configMap`:

- 1 replica
- one container using the image `mdimonte/angular-singleapp:v0.1`
- the `http` port being the port `8080` of the container
- 50m CPU and 50Mi of memory as requests
- 100m CPU and 100Mi of memory as limits
- the `configMap` that you have just created should be mounted over `/usr/share/nginx/html/assets` inside the container (this is where the frontend application expects its config file to be located)  

The frontend pod should start very quickly. Once it is ready, let's do some experiments:

> - Deploy the [helper pod](../helper/README.md) if it is not present yet
> - exec into the helper pod and access the backend via its `service`: `curl http://backend-svc/data`
> - exec into the helper pod and access the frontend via its `service`: `curl http://frontend-svc`
> - from your laptop run `curl http://step6.<your_name>.calpeabyla.com`
> - using your favorite browser navigate to `http://step6.<your_name>.calpeabyla.com`

## cleanup

As usual, clean the resources you deployed with `kubectl delete`. Don't forget you can pass the manifest files to delete the resources on the cluster.
