# Hands on n°8

## Objectives

Deploy the same application as the one used in [step5](../step-5/README.md) which was exposed via an ingress, and make it more secured by using TLS encryption.

## steps to run

> - in this scenario we will use an 'automated' DNS name leveraging the cluster wildcard domain name: `step8.<your_name>.calpeabyla.com`

## Generate a self-signed certificate

> use this option if it takes too long (for this exercise) to get your 'real' certificate
> Please, note that this is only for testing purpose and using such certificates is not a viable option neither in production nor in any other real environment (indus, QA, dev ...)

```bash
openssl req -x509 -nodes -days 3560 -newkey rsa:4096 -sha256 \
-keyout step8.<your_name>.calpeabyla.com.key \
-out step8.<your_name>.calpeabyla.com.crt \
-subj "/CN=step8.<your_name>.calpeabyla.com/O=step8.<your_name>.calpeabyla.com" \
-extensions san \
-config <( \
 echo "[req]"; \
 echo "distinguished_name=req"; \
 echo "[san]"; \
 echo "subjectAltName=DNS:step8.<your_name>.calpeabyla.com" \
 )
```

## Push the certificate to the Kubernetes cluster

To use a certificate in a Kubernetes cluster, we obviously need to upload it. As it is a common practice, Kubernetes has a resource type dedicated to storing certificates so that pods or other components can use them when needed: the [`secrets`](https://kubernetes.io/docs/concepts/configuration/secret/) of type `kubernetes.io/tls`.  
They are regular Kubernetes `secrets` with a static format to have something standard across every cluster and application.

With the certificate files previously generated, we can write our own `secret` manifest. Once it is done, let' deploy it like any other resource with `kubectl`.

## Deploy the application

The target application is the same as the application as the [hands on n°5](../step-5/README.md) plus a certificate for the ingress, so you can copy the manifest files if you have them, or refer to the instructions to write them now.

Before deploying them, we want to change the ingress configuration to leverage from the certificate we have create. with the help of the [Kubernetes documentation](https://kubernetes.io/docs/concepts/services-networking/ingress/#tls), add the `tls` attribute into your `ingress`.

Once it is done, deploy the application resources and check with your web browser that the certificate is the one you deployed.

> If you used a self-signed certificate you should get warning messages when trying to access the app

## cleanup

Clean the resources on your namespace with `kubectl delete`.
