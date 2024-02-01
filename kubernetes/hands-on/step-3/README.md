# Hands on n°3

## Objectives

Build a container image and then use that image in a Kubernetes `deployment`.

## Build the container image

> note that for the sake of the simplicity, we are going to use `docker` to build the container image here.
> however, in a real life scenario we recommend to use `kaniko`

First let's build the image you will use in this exercise. To do this you will write a `Dockerfile`:

- To be based on Ubuntu
- To have updated `nginx` and `curl` packages
- To have the provided custom nginx configuration `custom-nginx.conf` on your container on the path `/etc/nginx/nginx.conf`
- To have the provided default config `default.conf` in `/etc/nginx/conf.d/`
- And to start with the command `nginx -g daemon off;`

Information about dockerfiles can be found on the official [Docker documentation](https://docs.docker.com/get-started/).

Once your `Dockerfile` is ready, you can build the docker image with the Docker CLI, with the command `docker build`.  
:bulb: note that in order to push it to the docker hub, you must have an docker.io account

## Push the image to hub.docker.com

With the image built and stored locally, you can push it to an image repository for it to be available everywhere: we are goign to use the official [Docker Hub](https://hub.docker.com/). Before pushing, please login with `docker login` using an access token.  
:bulb: on the Docker hub, navigate to `My Account > Security > Access Tokens` and click on `New Access Token`

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
