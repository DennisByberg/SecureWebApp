#!/bin/bash

#---------------------------------------------------------------------------------------
# This script provisions an Azure VM with the specified configuration using the Azure CLI.
# The script creates a resource group, provisions a VM, and opens a port for the specified application.
# The script also prints out information about the VM and how to SSH into it.

# Script written by: Dennis Byberg, 2025-03-20, https://www.github.com/dennisbyberg
#---------------------------------------------------------------------------------------

RESOURCE_GROUP="SecureWebAppRG" # Resource group for the VM
VM_NAME="SecureWebAppVM"        # Name of the VM
VM_PORT="5000"                  # Port to open for the application
LOCATION="swedencentral"        # Location of the VM
IMAGE="Ubuntu2204"              # Image for the VM
SIZE="Standard_B1s"             # Size of the VM, e.g., Standard_B1s, Standard_D2s_v3
ADMIN_USERNAME="azureuser"      # Username for the VM

CLOUD_INIT_FILE="cloud-init_dotnet.yaml" # Cloud-init file for configuring the VM

# Function to check the exit status of the last command and exit if it failed
check_exit_status() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Create a resource group
echo "Creating resource group $RESOURCE_GROUP..."
az group create \
    --location $LOCATION \
    --name $RESOURCE_GROUP
check_exit_status "Failed to create resource group"

# Provision a VM
echo "Provisioning VM $VM_NAME..."
az vm create \
    --name $VM_NAME \
    --resource-group $RESOURCE_GROUP \
    --image $IMAGE \
    --size $SIZE \
    --generate-ssh-keys \
    --admin-username $ADMIN_USERNAME \
    --custom-data @$CLOUD_INIT_FILE
check_exit_status "Failed to create VM"

# Open a port for the application
echo "Opening port $VM_PORT for the application..."
az vm open-port \
    --port $VM_PORT \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME
check_exit_status "Failed to open port $VM_PORT"

# Get the public IP address of the VM
echo "Getting public IP address of the VM..."
PUBLIC_IP=$(az vm show \
    --name $VM_NAME \
    --resource-group $RESOURCE_GROUP \
    --show-details \
    --query publicIps \
    --output tsv)
check_exit_status "Failed to get public IP address"

# Print out information about the VM
echo "The VM has been provisioned with the public IP address: $PUBLIC_IP"
echo "You can now SSH into the VM using the following command:"
echo "ssh $ADMIN_USERNAME@$PUBLIC_IP"
