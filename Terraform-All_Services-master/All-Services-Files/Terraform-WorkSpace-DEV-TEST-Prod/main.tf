resource "azurerm_resource_group" "dev-rg" {
  name     = var.resource_group_names[terraform.workspace]
  location = "westeurope"
}