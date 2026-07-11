#!/bin/bash

minikube addons enable metrics-server
minikube dashboard
minikube addons enable yakd

