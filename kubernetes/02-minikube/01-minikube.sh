#!/bin/bash

unset KUBECONFIG
minikube start --driver=docker --nodes=1 --cpus=2 --memory=8192

