resource "azurerm_resource_group" "Resource-Group" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

#Key Vault

data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "key-vault" {
  name                        = var.keyvault_name
  location                    = azurerm_resource_group.Resource-Group.location
  resource_group_name         = azurerm_resource_group.Resource-Group.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
      "list",
      "set",
      "delete"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

#Make KeyVault Private by using below, by default Deny

# network_acls {
  #   default_action = "Deny" # "Allow" 
  #   bypass         = "AzureServices" # "None"
  #   ip_rules = ["50.50.50.50/24"]
  # }



# Key-Vault Secrets

resource "azurerm_key_vault_secret" "KV-Secrets" {
  name         = "secret-sauce"
  value        = "szechuan"
  key_vault_id = azurerm_key_vault.key-vault.id
}


# resource "azurerm_key_vault_access_policy" "policy" {
#   key_vault_id = azurerm_key_vault.keyvault.id
#
#   tenant_id = data.azurerm_client_config.current.tenant_id
#   object_id = "11111111-1111-1111-1111-111111111111" # SPN ID
#
#   key_permissions = [
#     "get",
#   ]
#
#   secret_permissions = [
#     "get",
#   ]
# }