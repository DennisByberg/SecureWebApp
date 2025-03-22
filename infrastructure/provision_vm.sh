#!/bin/bash

# Repetitive Variables || Important Variables
RESOURCE_GROUP="SecureWebAppRG"
VNET_NAME="SecureWebAppVNet"
SUBNET_NAME="SecureWebAppSubnet"
NSG_NAME="SecureWebAppNSG"
APP_VM_NAME="SecureWebAppVM"
LOCATION="swedencentral"
IMAGE="Ubuntu2204"
SIZE="Standard_B1s"
ADMIN_USERNAME="azureuser"

# Create a resource group
az group create \
    --location $LOCATION \
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
    --name Allow-SSH-App \
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

# Provision the application server VM with cloud-init
az vm create \
    --name $APP_VM_NAME \
    --resource-group $RESOURCE_GROUP \
    --image $IMAGE \
    --size $SIZE \
    --vnet-name $VNET_NAME \
    --subnet $SUBNET_NAME \
    --nsg $NSG_NAME \
    --generate-ssh-keys \
    --admin-username $ADMIN_USERNAME \
    --custom-data @cloud-init_dotnet.yaml
