#!/bin/bash

# ------------------------------------
# Sammanfattning av vad som skapas:
# ------------------------------------
# Resursgrupp
# VM med OS-disk
# Virtuellt nätverk med subnät
# Offentlig IP-adress
# Nätverksgränssnitt
# Nätverkssäkerhetsgrupp med regler för: SSH (port 22) & applikationsport (5000)
# SSH-nyckelpar för autentisering
# Lagringskonto för diagnostik
# ------------------------------------

RESOURCE_GROUP="SecureWebAppRG" # Resource group for the VM
VM_NAME="SecureWebAppVM"        # Name of the VM
VM_PORT="5000"                  # Port to open for the application
LOCATION="swedencentral"        # Location of the VM
IMAGE="Ubuntu2204"              # Image for the VM
SIZE="Standard_B1s"             # Size of the VM
ADMIN_USERNAME="azureuser"      # Username for the VM

CLOUD_INIT_FILE="cloud-init_dotnet.yaml" # Cloud-init file for configuring the VM

# Create a resource group
az group create \
    --location $LOCATION \
    --name $RESOURCE_GROUP

# Provision a VM
az vm create \
    --name $VM_NAME \
    --resource-group $RESOURCE_GROUP \
    --image $IMAGE \
    --size $SIZE \
    --generate-ssh-keys \
    --admin-username $ADMIN_USERNAME \
    --custom-data @$CLOUD_INIT_FILE

# Open a port for the application
az vm open-port \
    --port $VM_PORT \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME
