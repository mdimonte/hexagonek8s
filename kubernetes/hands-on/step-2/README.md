# Hands on n°2

## Objectives

Run a few first PODs and discover some basics of Kubernetes.

## Create a pod manifest

First, we want to create a simple pod with one container so we only need to specify an image for the container and Kubernetes will fill out most of the other fields with default values.

For the image we will use a modified Nginx that can run without being root in the container, as being root when it is not needed is a bad practice for security. The image can be found here: [nginxinc/nginx-unprivileged:latest](https://hub.docker.com/r/nginxinc/nginx-unprivileged)

**Hint**: It is hard to remember all the required fields and the manifest structure, so checking the [Kubernetes documentation](https://kubernetes.io/docs/home/) is the way to go.

## Deploying the pod

Once your manifest is ready, it can be deployed to the Kubernetes cluster. The main command to deploy resources on a Kubernetes cluster is `kubectl apply`, as it respects the declarative model of the technology.

## Checking the result

Once it is deployed, you can check the resources on the namespace with `kubectl get [resource]`.

To get a more detailed view and watch the events related to a resource, you can use `kubectl describe [resource]`.

Finally, you can get the logs of a container with `kubectl logs [pod name]`.

Please pay attention to the following points:

> - look at the IP@ assigned to the pod
> - look at the default amount of hardware resources assigned to the pod
> - look at the events associated to the pod
> - access the logs of the pod

## Fix the issue with the pod

As you saw, there are very limited resources assigned by default to the pod. This is enough for this image but it is better if the hardware resources given to a pod are controlled. Based on the information retrieved previously, add the required configuration to your pod manifest to set the resources yourself.

**Hint**: Once again the documentation is very helpful, for example there is [a page on how resources are managed](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)

To deploy the new pod, you have to delete the old one (with `kubectl delete`). There is a better way to deploy pods but for now let's keep things simple (we will see it in step 3 😉).

> - check the amount of hardware resources assigned to the pod
> - access the logs of the pod
> - exec into the pod and `curl http://localhost:8080`
> - access the logs of the pod again

## cleanup

Let's cleanup the namespace for the next steps. It should only contain the pod you deployed but checking what is deployed with `kubectl get` is always good.

**Remark**: `kubectl delete` works with the target type and name but it also works if you give it a manifest.

For example, to delete the resource described in the file `my_resource_to_delete`:

```bash
kubectl delete -f ./my_resource_to_delete.yml
```
