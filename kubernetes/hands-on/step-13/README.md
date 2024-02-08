# Hands on n°13

Deploy an application to demonstrate how to attach persistent storage to pods so that critical data is not lost across pods restarts.  

This exercice is split into two parts:

- highlight the problem we want to solve
- implement a solution that addresses the issue

In order to optimize the demonstration, we are going to use a real application made up of 2 µ-services: `wordpress` + `mysql`

## Highlighting the problem

### Deploying the database `mysql`

#### Create a `secret` documenting with these keys:

- `MYSQL_ROOT_PASSWORD` is the password of the `mysql` root user
- `MYSQL_USER` is the name of an additional user to create when `mysql` starts
- `MYSQL_PASSWORD` is the password to set for the user defined just above
- `MYSQL_DATABASE` is the name of a database to create when `mysql` starts

#### Create a deployment that will run the `mysql` DB with these attributes

- 1 replica
- one container using the image `mysql:8.0`
- the TCP port being used by `mysql` is `3306` of the container
- 100m CPU and 100Mi of memory as requests
- 200m CPU and 500Mi of memory as limits
- define environment variables from the keys defined in the `secret` above (they are expected by `mysql`):
  - `MYSQL_ROOT_PASSWORD`
  - `MYSQL_USER`
  - `MYSQL_PASSWORD`
  - `MYSQL_DATABASE`

> *as usual check the Kubernetes documentation 😉*

Then create a `service` of type `ClusterIP` matching pods of the `deployment` and routing the traffic from its port `3306` to the port `3306` of the backing pods.  

#### checking that `mysql` is running properly

- check the logs of the `mysql` pod to make sure that everythiong is working as expected
- check that there is an endpoint existing in the service (`kubectl describe service ...`)

### Deploying the application `wordpress`

#### Create a deployment that will run the `wordpress` component with these attributes

- 1 replica
- one container using the image `wordpress:latest`
- the TCP port being used by `wordpress` is `80` of the container
- 100m CPU and 100Mi of memory as requests
- 500m CPU and 500Mi of memory as limits
- define one environment variable called `WORDPRESS_DB_HOST` with the value `mysql`
- define additional environment variables from the keys defined in the `secret` above (they are expected by `wordpress`):
  - `WORDPRESS_DB_USER` defined from the secret key `MYSQL_USER`
  - `WORDPRESS_DB_PASSWORD` defined from the secret key`MYSQL_PASSWORD`
  - `WORDPRESS_DB_NAME` defined from the secret key`MYSQL_DATABASE`

Then create a `service` of type `ClusterIP` matching pods of the `deployment` and routing the traffic from its port `3306` to the port `3306` of the backing pods.  
Third, create an `ingress` listening on the host `wordpress.<your_name>.calpeabyla.com` and dispatching the inbound traffic to the port `80` of service you have create in the previous step.

### Demonstrating the problem

Now that the application is deployed and is reachable from your laptop, here are the actions to do:

- access the application and notice that there is an initial setup to apply
- simulate a failure of the pod running `mysql` (`kubectl delete pod ...`) and confirm that a new pod is started automatically to replace it
- refresh the application page.  
  note that it should take a few minutes for the app to resume  
  note also that when the app is back up&running, the initial setup must be re-executed: this because the data that was stored into the database of been lost when the `mysql` pod was restarted

Now, delete both `deployments`: the one for mysql and the one for wordpress

## Using `persistent storage`

The objective, here, is to demonstrate how we can secure the critical data that an application would write even if it is restarted.  
In Kubernetes this is achieved using what we call `PersistentVolumeClaims (PVC)`.  
Let's use a `PVC` to persist the content of the `mysql` databases.

Here are the steps to run:  

- create a `PVC` with these attributes (see [[here]](https://kubernetes.io/docs/concepts/storage/persistent-volumes) for the detailed documentation):
  - `storageClassName` should be `managed` (use `kubectl get storageclasses` to see all available `storage classes`)
  - sizing: `1Gi`
  - access mode set to `ReadWriteOnce`
- update the `deployment` manifest for `mysql` to leverage from this `PVC`: make sure to mount the volume inside the container at `/var/lib/mysql`
- recreate both deployments
- as previoulsy, access the application at `http://wordpress.<your_name>.calpeabyla.com`: again, you will have to re-execute the initialization process. Create a blog-post if you like ;)
- simulate a failure of the pod running `mysql` (`kubectl delete pod ...`) and confirm that a new pod is started automatically to replace it
- refresh the application page.  
  This time you can notice that the app is still rapidly available and that the content of the database is still existing.
  Tada!

## Cleanup

Clean the deployed resources to begin the next step with a clean environment.
