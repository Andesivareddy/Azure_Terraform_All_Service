# demo for importing existing infrastructure into Terraform configuration files
# create an Azure Resource Group and a Storage Account
az group create -g myResourceGroup -l westeurope
az storage account create -g myResourceGroup -n tfsademo01

# in main.tf we created the tf resource for the resource group & storage account

# init terraform's Azure provider
terraform init

# replace $SUBSCRIPTION_ID with your own subscription ID
$SUBSCRIPTION_ID="replace here"

# import the above created resource group into terraform state file
terraform import azurerm_resource_group.rg '/subscriptions/$SUBSCRIPTION_ID/resourceGroups/myResourceGroup'

# importing the resource group doesn't automatically import its child resources
# import the storage account
terraform import azurerm_storage_account.storage '/subscriptions/$SUBSCRIPTION_ID/resourceGroups/myResourceGroup/providers/Microsoft.Storage/storageAccounts/tfsademo01'

# check the content of the terraform.state file to notice a new section for the RG
# starting from now, we can manage this resource group using terraform
# try for example to rename the resource group in main.tf , then preview the changes

# plan and preview terraform changes
terraform plan

# cleanup created resources
az group delete -g myResourceGroup


#Import Resources with Terrafy

# Generate Terraform configuration and state from existing Azure resources

# Install Azure Terrafy
go install github.com/Azure/aztfy@latest

# Azure Terrafy commands
aztfy

# Azure Terrafy needs an empty folder to export config
mkdir terraform-web-sql

# Generate Terraform configuration and state file
aztfy -o terraform-web-sql rg-terraform-web-sql-db


# Import Terraform Exist Configuration into Main.tf file

# create resource group
$rg_id=$(az group create --name rg-terraform --location westeurope --query id --output tsv)

# create storage account
$storage_account_id=(az storage account create --name tfsa123579 --resource-group rg-terraform --location westeurope --sku Standard_LRS --query id --output tsv)

# create container
$container_id=(az storage container create --name tfstate --account-name tfsa123579 --auth-mode login --query id --output tsv)

# create function app
$function_id=(az functionapp create --resource-group rg-terraform --consumption-plan-location westeurope --name functionapp-terraform --storage-account tfsa123579 --runtime node --query id --output tsv)

# create key vault
$keyvault_id=(az keyvault create --resource-group rg-terraform --name kv12357913tf01 --location westeurope --query id --output tsv)

# create key vault secret
$keyvault_secret_id=(az keyvault secret set --vault-name kv12357913tf --name terraform-backend-key --value "terraform-backend-key" --query id --output tsv)

# create vm
$vm_id=(az vm create --resource-group rg-terraform --name vm-terraform --image UbuntuLTS --admin-username azureuser --generate-ssh-keys --query id --output tsv)

# create app service plan
$appservice_plan_id=(az appservice plan create --resource-group rg-terraform --name asp-terraform --sku B1 --is-linux  --query id --output tsv)

# create app service
$appservice_id=(az webapp create --resource-group rg-terraform --plan asp-terraform --name webapp-terraform --runtime "java:11:JavaSE:11" --query id --output tsv)

# create container app environment
$containerapp_environment_id=(az containerapp env create --resource-group rg-terraform --name containerapp-terraform --location westeurope --query id --output tsv)

# create container app
$containerapp_id=(az containerapp create --resource-group rg-terraform --name containerapp-terraform --environment containerapp-terraform --cpu 0.25 --memory 0.5 --image nginx --query id --output tsv)

# create AKS cluster
$aks_id=(az aks create --resource-group rg-terraform --name aks-terraform --node-count 1 --query id --output tsv)

# create AKS cluster with node pool
$aks_nodepool=(az aks nodepool add --resource-group rg-terraform --cluster-name aks-terraform --node-count 1 --node-vm-size Standard_B1s --name npapps --node-count 1 --node-vm-size Standard_B2s --query id --output tsv)

# # create vnet
# $vnet_id=(az network vnet create --resource-group rg-terraform --name vnet-terraform --address-prefixes ["10.0.0.0/8"] --query id --output tsv)

# # create subnet
# $subnet_id="{$vnet_id}/subnets/subnet-terraform"

@"
import {
    id = "$rg_id"
    to = azurerm_resource_group.main
}

import {
    id = "$storage_account_id"
    to = azurerm_storage_account.main
}

import {
    id = "$container_id"
    to = azurerm_storage_container.main
}

import {
    id = "$function_id"
    to = azurerm_function_app.main
}

import {
    id = "$keyvault_id"
    to = azurerm_key_vault.main
}

import {
    id = "$keyvault_secret_id"
    to = azurerm_key_vault_secret.main
}

import {
    id = "$vm_id"
    to = azurerm_virtual_machine.main
}

import {
    id = "$appservice_plan_id"
    to = azurerm_app_service_plan.main
}

import {
    id = "$appservice_id"
    to = azurerm_app_service.main
}

import {
    id = "$containerapp_environment_id"
    to = azurerm_container_app_environment.main
}

import {
    id = "$containerapp_id"
    to = azurerm_container_app.main
}

import {
    id = "$aks_id"
    to = azurerm_kubernetes_cluster.main
}

import {
    id = "$aks_nodepool"
    to = azurerm_kubernetes_cluster_node_pool.main
}

# import {
#     id = "$vnet_id"
#     to = azurerm_virtual_network.main
# }

# import {
#     id = "$subnet_id"
#     to = azurerm_subnet.main
# }

"@ > main.tf


# start importing existing resources to terraform configuration

terraform init

terraform plan -generate-config-out="generated.tf"






