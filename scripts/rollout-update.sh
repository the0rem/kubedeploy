#!/bin/bash

# Parse arguments
usage() {
    echo "Usage: $0 [-h] [-v] [-f FILE]"
    echo "  -h  Help. Display this message and quit.
    echo "  -v  Version. Print version number and quit.
    echo "  -f  Specify configuration file FILE."
    exit
}


deployDelay=10
deploymentName=update-demo-nautilus
newDeploymentFile=examples/update-demo/kitten-rc.yaml

while (( $# > 0 ))
do
    opt="$1"
    shift

    case $opt in
	    --help)
	        helpfunc
	        exit 0
	        ;;
	    --version)
	        echo "$0 version $version"
	        exit 0
	        ;;
	    --file)  # Example with an operand
	        filename="$1"
	        shift
	        ;;
	    --*)
	        echo "Invalid option: '$opt'" >&2
	        exit 1
	        ;;
	    *)
	        # end of long options
	        break;
	        ;;
   esac

done

# Runs a graceful update of the deployed applicaiton
kubectl rolling-update "$deploymentName" --update-period="$deployDelay"s -f "$newDeploymentFile"