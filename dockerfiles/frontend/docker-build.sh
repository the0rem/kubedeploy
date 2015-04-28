#!/bin/bash

# Builds the Dockerfile with the given project:tag and pushes to docker hub

# Parse arguments
usage() {
    echo "Usage: $0 [-h] [-v] [-t Tag] [-f Dockerfile]"
    echo "  -h --help  Help. Display this message and quit."
    echo "  -v --version Version. Print version number and quit."
    echo "  -p --project What project the build is for"
    echo "  -t --tag What tag to add to build (Default: latest)"
    # echo "  -f --file What Dockerfile to use (Default: ./Dockerfile)"
    echo "  -b --build-only Will only build the Dockerfile and store locally"
    echo " 	-c --no-cache Will build image without using cached layers of image"
    exit
}

DOCKER_HUB_USER=${DOCKER_HUB_USER}
DOCKER_HUB_EMAIL=${DOCKER_HUB_EMAIL}
DOCKER_HUB_PASS=${DOCKER_HUB_PASS}
DOCKER_PROJECT_NAME=${DOCKER_PROJECT_NAME}

buildOnly=""
sourceFilePrefix="."
buildTag="latest"
# dockerFile="."
dockerDir=$(dirname "${dockerfile}")
credentials="./.credentials_github"
noCache=''

# Set credentials for github data
if  [ -f $credentials ]; then
	source $credentials
fi

while (( $# > 0 ))
do
    option="$1"
    shift

    case $option in
    -h|--help)
        usage
        exit 0
        ;;
    -v|--version)
        echo "$0 version $version"
        exit 0
        ;;
    -t|--tag)
        buildTag="$1"
        ;;
    -f|--file)
        dockerFile="$1"
        ;;
    -p|--project)
		DOCKER_PROJECT_NAME="$1"
		;;
	-b|--build-only)
        buildOnly=1
        ;;
    -c|--no-cache)
		noCache="--no-cache=true"
		;;
    -*)
        echo "Invalid option: '$opt'" >&2
        exit 1
        ;;
   esac

done

docker build "${noCache}" -t "${DOCKER_HUB_USER}/${DOCKER_PROJECT_NAME}:${buildTag}" .

if [ -z $buildOnly ]; then

	docker login --email="${DOCKER_HUB_EMAIL}" --password="${DOCKER_HUB_PASS}" --username="${DOCKER_HUB_USER}"
	docker push "${DOCKER_HUB_USER}/${DOCKER_PROJECT_NAME}:${buildTag}"

fi