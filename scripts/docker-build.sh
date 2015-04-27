#!/bin/bash

# Builds the Dockerfile with the given tag

set -o errexit
set -o nounset
set -o pipefail

source ./.env

DOCKER_HUB_USER=${DOCKER_HUB_USER}
DOCKER_HUB_EMAIL=${DOCKER_HUB_EMAIL}
DOCKER_HUB_PASS=${DOCKER_HUB_PASS}
DOCKER_PROJECT_NAME=${DOCKER_PROJECT_NAME}
DOCKER_PROJECT_TAG=${DOCKER_PROJECT_TAG}

set -x

docker build -t "${DOCKER_HUB_USER}/${DOCKER_PROJECT_NAME}:${DOCKER_PROJECT_TAG}" images/kitten
docker login --email="${DOCKER_HUB_EMAIL}" --password="${DOCKER_HUB_PASS}" --username="${DOCKER_HUB_USER}"
docker push "${DOCKER_HUB_USER}/update-demo"