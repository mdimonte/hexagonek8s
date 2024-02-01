# Hands on n°5

Deploy an application component (a micro-service) and make it accessible from outside the Kubernetes cluster.

## Deploy the app component

Make a `deployment` manifest to deploy 3 pods (replicas) with the image `mdimonte/single-app:v0.1` and the same characteristics as in the previous exercise, and make a `service` manifest that match with the deployment, then deploy them on your namespace.

## Access the app from outside the cluster

After this, we want to access the application like we did in the previous exercise but from **outside** the cluster. For this, there is a Kubernetes resource called [`ingress`](https://kubernetes.io/docs/concepts/services-networking/ingress/). Take some time to read the first few parts of the documentation in order to better understand what this resource does.

Once you have roughly understood what the ingress does, create a manifest for an `ingress` that dispatches the traffic for the host `<my-app>.my-corp.com` to the port `80` of the `service` you have created.

Now try to access the application using the host that you have documented in the ingress in your favorite web browser.

> - in this scenario we use an 'automated' DNS name leveraging the cluster wildcard domain name: `<my-app>.my-corp.com`

## cleanup

As usual, cleanup the resources to have a clean namespace.
