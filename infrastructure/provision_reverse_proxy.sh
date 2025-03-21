#!/bin/bash

# Repetitive Variables || Important Variables
PROXY_VM_NAME="ReverseProxyVM"
RESOURCE_GROUP="SecureWebAppRG"
VNET_NAME="SecureWebAppVMVNET"
NSG_NAME="SecureWebAppVMNSG"
SIZE="Standard_B1s"
ADMIN_USERNAME="azureuser"
IMAGE="Ubuntu2204"

# Provision the reverse proxy VM with the updated cloud-init_nginx.yaml
az vm create \
    --name $PROXY_VM_NAME \
    --resource-group $RESOURCE_GROUP \
    --image $IMAGE \
    --size $SIZE \
    --vnet-name $VNET_NAME \
    --subnet SecureWebAppVMSubnet \
    --nsg $NSG_NAME \
    --generate-ssh-keys \
    --admin-username $ADMIN_USERNAME \
    --custom-data @cloud-init_nginx.yaml

# Open a port for HTTP on the reverse proxy VM
az vm open-port \
    --port 80 \
    --resource-group $RESOURCE_GROUP \
    --name $PROXY_VM_NAME \
    --priority 1001

# Open a port for SSH on the reverse proxy VM
# az network nsg rule create \
#     --resource-group $RESOURCE_GROUP \
#     --nsg-name $NSG_NAME \
#     --name Allow-SSH-Proxy \
#     --priority 1002 \
#     --destination-port-ranges 22 \
#     --protocol Tcp \
#     --access Allow \
#     --direction Inbound

# Create a rule to explicitly block public access to the app VM's port 5000
# az network nsg rule create \
#     --resource-group $RESOURCE_GROUP \
#     --nsg-name $NSG_NAME \
#     --name Block-Direct-App-Access \
#     --priority 1004 \
#     --destination-port-ranges 5000 \
#     --protocol Tcp \
#     --source-address-prefixes Internet \
#     --access Deny \
#     --direction Inbound
