#!/bin/bash

VERSION=0.15.0

# git clone https://github.com/GoogleCloudPlatform/kubernetes
# pushd kubernetes
# git checkout -b v$VERSION tags/v$VERSION

/opt/bin/kubectl create -f redis-master-controller.json
/opt/bin/kubectl create -f redis-master-service.json
/opt/bin/kubectl create -f redis-slave-controller.json
/opt/bin/kubectl create -f redis-slave-service.json
/opt/bin/kubectl create -f frontend-controller.json
/opt/bin/kubectl create -f frontend-service.json
/opt/bin/kubectl get pods
