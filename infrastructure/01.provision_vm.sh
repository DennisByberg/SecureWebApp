#!/bin/bash

RESOURCE_GROUP="SecureWebAppRG" # Resursgrupp för VM
VM_NAME="SecureWebAppVM"        # Namn på VM
VM_PORT="5000"                  # Port för applikationen
LOCATION="swedencentral"        # Plats för VM
IMAGE="Ubuntu2204"              # Image för VM
SIZE="Standard_B1s"             # Storlek på VM, t.ex. Standard_B1s, Standard_D2s_v3
ADMIN_USERNAME="azureuser"      # Användarnamn för VM
NSG_NAME="${VM_NAME}-nsg"       # NSG för VM

CLOUD_INIT_FILE="cloud-init_dotnet.yaml" # Cloud-init-fil för att konfigurera VM

# Skapa en resursgrupp
az group create \
    --location $LOCATION \
    --name $RESOURCE_GROUP

# Skapa en NSG
az network nsg create \
    --resource-group $RESOURCE_GROUP \
    --name $NSG_NAME

# Skapa en regel för att tillåta SSH-anslutningar
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_NAME \
    --name "AllowSSH" \
    --priority 1000 \
    --destination-port-ranges 22 \
    --direction Inbound \
    --access Allow \
    --protocol Tcp \
    --description "Allow SSH connections"

# Skapa en regel för att tillåta anslutningar till applikationen
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name $NSG_NAME \
    --name "AllowAppTraffic" \
    --priority 1010 \
    --destination-port-ranges $VM_PORT \
    --direction Inbound \
    --access Allow \
    --protocol Tcp \
    --description "Allow application traffic"

# Provisionera en VM
az vm create \
    --name $VM_NAME \
    --resource-group $RESOURCE_GROUP \
    --image $IMAGE \
    --size $SIZE \
    --generate-ssh-keys \
    --admin-username $ADMIN_USERNAME \
    --custom-data @$CLOUD_INIT_FILE \
    --nsg $NSG_NAME
