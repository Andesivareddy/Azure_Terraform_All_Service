resource "azurerm_resource_group" "Resource-Group" {
  name     = var.resource_group_name
  location = var.resource_group_location
}


resource "azurerm_storage_account" "new-storage-Account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.Resource-Group.name
  location                 = azurerm_resource_group.Resource-Group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  #allow_blob_public_access = true

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "storage-container" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.new-storage-Account.name
  container_access_type = "container"
}

resource "azurerm_storage_blob" "blob" {
  name                   = "my-awesome-content.zip"
  storage_account_name   = azurerm_storage_account.new-storage-Account.name
  storage_container_name = azurerm_storage_container.storage-container.name
  type                   = "Block"
  source                 = "commands.sh"
}


