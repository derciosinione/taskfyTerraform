#!/bin/bash

# Configurações
RESOURCE_GROUP="Taskify"
CONTAINER_NAME="project-manager-api-back-v1"
ACR_NAME="taskfyacrregistry"
IMAGE_NAME="project-manager-api-back:v1"
DNS_NAME="project-manager-api-back-$RANDOM"

# Obter credenciais do ACR
echo "🔐 A obter credenciais do ACR..."
ACR_USERNAME=$(az acr credential show --name $ACR_NAME --query username -o tsv)
ACR_PASSWORD=$(az acr credential show --name $ACR_NAME --query passwords[0].value -o tsv)

# Criar o container
echo "🚀 A lançar o container em Azure Container Instances..."
az container create \
  --resource-group $RESOURCE_GROUP \
  --name $CONTAINER_NAME \
  --image $ACR_NAME.azurecr.io/$IMAGE_NAME \
  --registry-login-server $ACR_NAME.azurecr.io \
  --registry-username $ACR_USERNAME \
  --registry-password $ACR_PASSWORD \
  --dns-name-label $DNS_NAME \
  --ports 8080 \
  --cpu 1 \
  --memory 1.5 \
  --os-type Linux

# Mostrar o endpoint público
echo "🌐 Endpoint da API:"
az container show \
  --resource-group $RESOURCE_GROUP \
  --name $CONTAINER_NAME \
  --query ipAddress.fqdn \
  --output tsv
