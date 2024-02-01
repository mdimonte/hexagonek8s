# Hands on n°1

Simply make sure that we do have access to a kubernetes namespace.

## `kubectl` config file

Setup the config file used by kubectl (often called a `kubeconfig` file). There are multiple ways to do it, pick the one that you like the most:

- the default config file is `~/.kube/config`
- it is also possible to  document the option `--kubeconfig=xxxx` on the `kubectl` command-line
- or to set an environment variable called `KUBECONFIG` to the location of your kubeconfig files (‘:’ separated)
  i.e.

  ```bash
  export KUBECONFIG="/path/to/file1:/path/to/file2"
  ```

## Verification

Now that the configuration is set up, the kubectl commands should work, you can try to get the `version` of the cluster, some `information` related to the cluster and the resources that you have in your namespace (not a lot for now 🙂).
