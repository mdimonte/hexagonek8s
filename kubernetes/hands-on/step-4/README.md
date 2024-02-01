# Hands on n°4

Deploy an application component (a micro-service) and make it accessible through a `service`.
This `service` will act as a stable (i.e. non ephemeral) endpoint to the pods running the application logic.
It will also load-balance the incoming traffic to the pods behind it.

## Deploy the app component

First let's deploy another `deployment`, we want it to have:

- 3 replicas
- one container using the image `mdimonte/single-app:v0.1`
- the `http` port being the port `8000` of the container
- 30m CPU and 25Mi of memory as requests
- 80m CPU and 50Mi of memory as limits

> *as usual check the Kubernetes documentation 😉*

After this, we will create a [service](https://kubernetes.io/docs/concepts/services-networking/service/), after reading the documentation to learn what they do, write a manifest and deploy the service to the cluster. Here the service should be of type `ClusterIP` and *select* the labels of the deployment above.

Finally, as usual, describe the created resource to check its configuration. You can also play with the application pods to see how the service reacts.

> - notice the `endpoints` associated to the service which proves that when sending requests to the service, there are backing pods behind it
> - Deploy the [helper pod](../helper/README.md)
> - exec into the helper pod and `curl http://<SVC IP@>:80`
> - notice that the incoming traffic to the `service` is load-balanced across the `pods`
> - notice that the life-cycle of the `service` is not tied to the ones of the `pods`, `rs` or `deployment`

## Cleanup

Clean the deployed resources to begin the next step with a clean environment.
