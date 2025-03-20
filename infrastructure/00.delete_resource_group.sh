#!/bin/bash

# Exit script on error
set -e

# Function to display a spinner
show_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    local end_time=$((SECONDS + 120)) # Run the spinner for about 60 seconds

    echo "Waiting for deletion to complete (estimated about 2 minute)..."

    while [ $SECONDS -lt $end_time ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Prompt for resource group name
echo "Enter the name of the resource group you want to delete:"
read resourceGroupName

# Check if the resource group exists
echo "Checking if resource group '$resourceGroupName' exists..."
if az group exists --name "$resourceGroupName" | grep -q "true"; then
    echo "Resource group '$resourceGroupName' found."
    echo "WARNING: This will delete ALL resources in the resource group '$resourceGroupName'."
    echo "Are you sure you want to continue? (y/n)"
    read confirmation

    if [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
        echo "Deleting resource group '$resourceGroupName'..."
        az group delete --name "$resourceGroupName" --yes --no-wait

        # Show spinner while deletion is in progress
        show_spinner

        echo "Deletion process has been initiated. The resource group and all its resources should now be deleted."
        echo "If all resources haven't been deleted yet, it may take additional time to complete."
    else
        echo "Operation cancelled."
    fi
else
    echo "Resource group '$resourceGroupName' could not be found."
fi
