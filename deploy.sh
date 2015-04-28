#!/bin/bash

# Builds deployment yaml files using dev .env file injected


# Parse arguments
usage() {
    echo "Usage: $0 [-h] [-v] -e ENV"
    echo "  -h --help  Help. Display this message and quit."
    echo "  -v --version Version. Print version number and quit."
    echo "  -d --dir Specify the distribution directory."
    echo "  -e --env Specify configuration file FILE."
    echo "  -u --update Whether to update a current deployment"
    exit
}

distDir="${PWD}/dist"
environment="dev"
envFile=""
sourceFilePrefix=".kubectl_"

update=0
deployDelay=10

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
    -e|--env)  # Example with an operand
        environment="$1"
        shift
        ;;
    -d|--dir)  # Example with an operand
        distDir="$1"
        shift
        ;;
    -u|--update)  # Example with an operand
        update=1
        ;;
    -*)
        echo "Invalid option: '$opt'" >&2
        exit 1
        ;;
    *)
        # end of long options
        break;
        ;;
   esac

done

if [ ! $envFile ]; then
    envFile=${sourceFilePrefix}${environment}
fi

if [ ! -f $envFile ]; then
    echo "Environment file '$envFile' cannot be sourced" >&2
    exit 1
fi

source $envFile

# We only want to update
if [ $update -eq 1 ]; then
    for file in $distDir/*.yaml; do

        isReplicationController=$(grep 'kind: ReplicationController' $file)
        
        if [ -z $isReplicationController ]; then
            # Runs a graceful update of the deployed applicaiton
            kubectl rolling-update "$deploymentName" --update-period="$deployDelay"s -f "$newDeploymentFile"
        fi

    done
else 

    # Build tempaltes using environmental variables
    for file in $distDir/*.yaml; do

        kubectl create -f $file
        echo "Creating $file"

    done
fi

kubectl cluster-info
kubectl get minions
kubectl get services
kubectl get replicationcontrollers
kubectl get pods
