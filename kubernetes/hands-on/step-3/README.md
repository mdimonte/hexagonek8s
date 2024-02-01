# Hands on n°3

## Objectives

Build a container image and then use that image in a Kubernetes `deployment`.

## Build the container image

> note that for the sake of the simplicity, we are going to use `docker` to build the container image here.
> however, in a real life scenario we recommend to use `kaniko`

First let's build the image you will use in this exercise. To do this you will write a `Dockerfile`.

Michelin environment has a few specificities, so it is easier to use images already configured for Michelin. They can be found in the [Michelin Docker Hub](https://gitlab.michelin.com/DEV/docker/michelin-docker-hub). There is also a lot of documentation on [dev.michelin.com](https://dev.michelin.com/digital-sustainability/docker) about optimizations and best practices.

For now let's focus on the `Dockerfile` creation. We want the image:

- To be based on Ubuntu
- To have updated `nginx` and `curl` packages
- To have the provided custom nginx configuration `custom-nginx.conf` on your container on the path `/etc/nginx/nginx.conf`
- To have the provided default config `default.conf` in `/etc/nginx/conf.d/`
- And to start with the command `nginx -g daemon off;`

Information about dockerfiles can be found on [dev.michelin.com](https://dev.michelin.com/docker/dockerfile) and on the official [Docker documentation](https://docs.docker.com/get-started/).

Once your `Dockerfile` is ready, you can build the docker image with the Docker CLI, with the command `docker build`. In order to push it to the correct repository in Michelin's Artifactory, the image has to be tagged accordingly. For this exercise we will use `docker-snapshot.artifactory-cn.michelin.com/k8s/hands-on/$LOGNAME-step3:latest`, with `$LOGNAME` being your user name (this is a standard Linux shell environment variable that is alrady set for you at login time).

## Push the image to Artifactory

With the image built and stored locally, you can push it to an image repository for it to be available everywhere. Michelin has such a repository on Artifactory with `docker-snapshot.artifactory-cn.michelin.com`. Before pushing, please login with `docker login` and your Artifactory personal token.

One you are logged in you only have to push your image with `docker push`!

## Use the image in a Kubernetes `deployment`

In the previous exercise, the pod management was very manual and more imperative than declarative so we will use a more appropriate resource to have a pure declarative behavior and leverage more Kubernetes features.

This resource is a [`deployment`](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/). With the image previously pushed to Artifactory, and the help of the Kubernetes documentation, let's create a deployment manifest and deploy it in your namespace.

We want the deployment to have the following specs:

- 3 replicas
- one container using the image you just pushed
- the `http` port being the port `8080` of the container
- 100m CPU and 100Mi of memory as requests
- 200m CPU and 200Mi of memory as limits

Once your manifest is ready, `apply` it to the cluster.

**Remark**: While `kubectl delete` and `kubectl create` exist and are useful during development, they usually should not be used for updating a deployment as they are not idempotent and a lot of useful features are lost.

## Checking the results

A `deployment` is more complex than a pod, and it generates intermediate resources, notably [`replicasets`](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/) that manage pods.

As done in the previous exercise, let's `describe` the deployment that you created. This gives a lot of information parsed to a *human readable* format and to have the raw manifest stored in the cluster, you can use `kubectl get -o yaml`. This can be used when describe hides some information or to use it in a script. Once you are familiarized with the `describe` out put for the deployment, do the same for the `replicaset`.

With the deployment setup, you can observe what happens when a pod dies by deleting it with `kubectl delete`. Also notice what happens when you update the resources given to the pod.

## Cleanup

One again, clean your namespace with `kubectl delete` to start from a clean state on the next exercise.
