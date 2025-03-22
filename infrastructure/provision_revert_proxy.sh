#!/bin/bash

# Repetitive Variables || Important Variables
RESOURCE_GROUP="SecureWebAppRG"
VNET_NAME="SecureWebAppVNet"
SUBNET_NAME="SecureWebAppSubnet"
NSG_NAME="SecureWebAppNSG"
PROXY_VM_NAME="ReverseProxyVM"
LOCATION="swedencentral"
IMAGE="Ubuntu2204"
SIZE="Standard_B1s"
ADMIN_USERNAME="azureuser"

# Provision the reverse proxy VM with the updated cloud-init_nginx.yaml
az vm create \
    --name $PROXY_VM_NAME \
    --resource-group $RESOURCE_GROUP \
    --image $IMAGE \
    --size $SIZE \
    --vnet-name $VNET_NAME \
    --subnet $SUBNET_NAME \
    --nsg $NSG_NAME \
    --generate-ssh-keys \
    --admin-username $ADMIN_USERNAME \
    --custom-data @cloud-init_nginx.yaml

# Open a port for HTTP on the reverse proxy VM with a unique priority
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_NAME \
    --name Allow-HTTP \
    --priority 1002 \
    --destination-port-ranges 80 \
    --protocol Tcp \
    --access Allow \
    --direction Inbound

# Open a port for SSH on the reverse proxy VM with a unique priority
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_NAME \
    --name Allow-SSH-Proxy \
    --priority 1003 \
    --destination-port-ranges 22 \
    --protocol Tcp \
    --access Allow \
    --direction Inbound
