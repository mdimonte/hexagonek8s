# Hands on n°7

## objectives

Here we are going to look at what we can do to deploy an application on multiple environments (i.e. dev, qa, prod ...).
We will demonstrate how to 'variabilize' some parts of the Kubernetes manifests so that the configuration of the application best matches our requirements on each environment. For example, I might want 10 replicas in production and only 2 in development, or I might want to pull the images from different repositories when running in production, or even I might want to adjust the credentials to access the DB.

## Install `kustomize` on your laptop

Let's download and install the tool that we will use in this exercise: [`kustomize`](https://kustomize.io/). We will use the standalone version because it is easier to control the version with this form than the version shipped with `kubectl`.

```bash
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" > /tmp/install_kustomize.sh
sudo bash /tmp/install_kustomize.sh 4.5.7 /usr/local/bin
```

## Take a look at the `kustomize` documentation

As for every new tool, read the documentation, especially the [getting started part](https://kubectl.docs.kubernetes.io/guides/introduction/kustomize/).

> The core concepts of `kustomize` are:
>
> - the base layer
> - additional overlays that applies to specific environments

## Create the base layer

First, create a directory named `deploy` and in this directory create another one named `base`, so that our base layer will be in `deploy/base/`.

A `kustomize` base layer is made of slightly modified Kubernetes manifests and a file named `kustomization.yaml`. We will begin with the Kubernetes manifests as you should be familiar with how they work.

We want a `deployment` with:

- 1 replica
- one container using the image `fakeregistry.com/single-app`
- the `http` port being the port `8000` of the container
- 30m CPU and 25Mi of memory as requests
- 80m CPU and 50Mi of memory as limits
- the label `app: step-7-app`

A `service` matching the label `app: step-7-app` and routing the traffic from its port 80 to the `http` port of the backing pods.

An ingress matching the host `<my-app>.my-corp.com` and sending the incoming traffic to the port 80 of the `service` you have just created.

You may have noticed that the registry we used is special (i.e. totally wrong 😀). This is because we will replace it in the `kustomization.yaml` file.

This file is structured like a Kubernetes manifest and has some required fields:

- `resources`: a list of Kubernetes manifest file names. It is used by `kustomize` to know wat are the files to process.
- `apiVersion`: a value set to `kustomize.config.k8s.io/v1beta1`
- `kind`: a value set to `Kustomization`

With just the required config, nothing is modified. To change the image used by our `deployment` let's add the following:

```yaml
images:
- name: <the image to change>
  newName: mdimonte/single-app
  newTag: v0.1
```

This will replace our fake registry name with an actual and working one. It is not very useful for a single container, but for a more complex application it can make a nice code factorization.

You can check the results with `kustomize build deploy/base`.

## Create the overlays

Having a base layer is good, but the power of `kustomize` comes with applying different overlays.

Create the directories `deploy/environments`, `deploy/environments/dev` and `deploy/environments/qa` for our overlays related to dev and qa.

For now let's focus on `dev`, the overlays are made of 1 file called `kustomization.yaml` and one or more patch files.  
In the `kustomization.yaml` file, there are these fields:

- `resources`: a list that documents where the manifests are, in this case this is the base layer
- `patches`: a list of patch files to apply

Let's create the patches.  
Create two files called `deployment-patch.yaml` and `ingress-patch.yaml`. The content of a patch file is a Kubernetes manifest "stub", where 2 kinds of information is found:

- information needed to identify the resource to patch (`apiVersion`, `kind` and `name`)
- the fields we want to modify

For the dev overlay, we want the deployment to have **2 replicas** and a **`terminationGracePeriodSeconds` set to 1 second**. For the ingress we just want to **change the host to `<my-app>-dev.my-corp.com`**.

> **Note**: For the ingress patch, you may need to rewrite almost everything in the `rules` array.

Once it is done, test your overlay with `kustomize build deploy/environments/dev`.

Then you can do the same thing for the qa environment, this time we want the deployment to have **5 replicas** and a **`terminationGracePeriodSeconds` set to 10 seconds**. For the ingress we want to **change the host to `<my-app>-qa.my-corp.com`**.

## Deploy the app

Kustomize does not interact with the Kubernetes cluster, it only generates the manifests that can be ingested by `kubectl` onto the *standard output*. You can apply these manifests from the standard input piping the result of the `kustomize buid ...` command into `kubect apply -f -`.

So now pipe the `kustomize build` command into `kubectl` to deploy the different environments, one at a time.

## cleanup

Delete the deployed resources with `kubectl delete`.

> **Remark**: `kubectl delete` can also read the standard input with `kubectl delete -f -`.
