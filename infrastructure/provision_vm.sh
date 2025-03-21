#!/bin/bash

# Repetitive Variables || Important Variables
RESOURCE_GROUP="SecureWebAppRG"
VNET_NAME="SecureWebAppVNet"
SUBNET_NAME="SecureWebAppSubnet"
NSG_NAME="SecureWebAppNSG"
VM_NAME="SecureWebAppVM"

# Create a resource group
az group create \
    --location swedencentral \
    --name $RESOURCE_GROUP

# Create a virtual network
az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --name $VNET_NAME \
    --address-prefix 10.1.0.0/16 \
    --subnet-name $SUBNET_NAME \
    --subnet-prefix 10.1.0.0/24

# Create a network security group
az network nsg create \
    --resource-group $RESOURCE_GROUP \
    --name $NSG_NAME

# Create NSG rules for SSH and application port
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_NAME \
    --name Allow-SSH \
    --protocol tcp \
    --priority 1000 \
    --destination-port-range 22 \
    --access allow

az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_NAME \
    --name Allow-App-Port \
    --protocol tcp \
    --priority 1001 \
    --destination-port-range 5000 \
    --access allow

# Associate NSG with the subnet
az network vnet subnet update \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $VNET_NAME \
    --name $SUBNET_NAME \
    --network-security-group $NSG_NAME

# Provision a VM with cloud-init
az vm create \
    --name $VM_NAME \
    --resource-group $RESOURCE_GROUP \
    --image Ubuntu2204 \
    --size Standard_B1s \
    --vnet-name $VNET_NAME \
    --subnet $SUBNET_NAME \
    --generate-ssh-keys \
    --admin-username azureuser \
    --custom-data @cloud-init_dotnet.yaml
