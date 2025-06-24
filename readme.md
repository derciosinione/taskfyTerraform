terraform destroy -target=azurerm_private_endpoint.cosmosdb_private_endpoint



✅ 7. Push da imagem para o ACR

# Login no ACR
az acr login --name taskfyacrregistry

# Tag da imagem
docker tag taskfy-web taskfyacrregistry.azurecr.io/taskfy-web:latest

# Push
docker push taskfyacrregistry.azurecr.io/taskfy-web:latest

<!-- docker build -t taskfy-web . -->

docker run -p 8080:8080 taskfy-web



