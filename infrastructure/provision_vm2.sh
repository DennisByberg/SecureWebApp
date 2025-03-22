#!/bin/bash

RESOURCE_GROUP="SecureWebAppRG"
VM_NAME="SecureWebAppVM"

# Create a resource group
az group create \
    --location swedencentral \
    --name $RESOURCE_GROUP

# Provision a VM
az vm create \
    --name $VM_NAME \
    --resource-group $RESOURCE_GROUP \
    --image Ubuntu2204 \
    --size Standard_B1s \
    --generate-ssh-keys \
    --admin-username azureuser \
    --custom-data @cloud-init_dotnet.yaml

# Open a port for the application
az vm open-port \
    --port 5000 \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME
