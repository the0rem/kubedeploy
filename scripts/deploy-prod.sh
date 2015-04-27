#!/bin/bash

kubectl create -f redis/redis-master-controller.yaml
kubectl create -f redis/redis-master-service.yaml
kubectl create -f redis/redis-slave-controller.yaml
kubectl create -f redis/redis-slave-service.yaml
kubectl create -f mariadb/mariadb-volume.yaml
kubectl create -f mariadb/mariadb-controller.yaml
kubectl create -f mariadb/mariadb-service.yaml
kubectl create -f frontend/frontend-controller.yaml
kubectl create -f frontend/frontend-service.yaml
kubectl get pods
