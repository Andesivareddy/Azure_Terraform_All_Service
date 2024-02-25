resource "azurerm_resource_group" "Resource-Group" {
  name     = var.resource_group_name
  location = var.resource_group_location
}


resource "azurerm_kubernetes_cluster" "aks" {
  name                   = var.cluster_name
  kubernetes_version     = var.kubernetes_version
  location               = var.resource_group_location
  resource_group_name    = var.resource_group_name
  dns_prefix             = var.cluster_name
  local_account_disabled = true

  default_node_pool {
    name       = "systempool"
    node_count = var.system_node_count
    vm_size    = "Standard_DS2_v2"
  }


#service_principal {
   # client_id     = "00000000-0000-0000-0000-000000000000"
   # client_secret = "00000000000000000000000000000000"  }
   
  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    admin_group_object_ids = [azuread_group.aks_admins.object_id]
    tenant_id              = data.azurerm_subscription.current.tenant_id
  }
}