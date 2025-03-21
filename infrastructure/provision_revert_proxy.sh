#!/bin/bash

# Repetitive Variables || Important Variables
RESOURCE_GROUP="SecureWebAppRG"
VNET_NAME="SecureWebAppVNet"
SUBNET_NAME="SecureWebAppSubnet"
NSG_NAME="SecureWebAppNSG"
VM_NAME="ReverseProxyVM"

# Provision a VM
az vm create \
    --name $VM_NAME \
    --resource-group $RESOURCE_GROUP \
    --image Ubuntu2204 \
    --size Standard_B1s \
    --vnet-name $VNET_NAME \
    --subnet $SUBNET_NAME \
    --generate-ssh-keys \
    --admin-username azureuser \
    --custom-data @cloud-init_nginx.yaml

# Open a port for the application
az vm open-port \
    --port 80 \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME

# Open a port for SSH
az vm open-port \
    --port 22 \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME
