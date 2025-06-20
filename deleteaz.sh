# 1) Grab every lock ID under the RG
lock_ids=$(az lock list \
  --resource-group pergunta1 \
  --query "[].id" -o tsv)

# 2) Delete each lock
for id in $lock_ids; do
  az lock delete --ids "$id"
done

# 3) Finally delete the RG
az group delete \
  --name pergunta1 \
  --yes \
  --no-wait
