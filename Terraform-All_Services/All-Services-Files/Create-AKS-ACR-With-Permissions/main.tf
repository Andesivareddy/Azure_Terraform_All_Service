resource "azurerm_resource_group" "Resource-Group" {
  name     = var.resource_group_name
  location = var.resource_group_location
}


#Permissions to attach ACR to AKS


resource "azurerm_role_assignment" "permissions_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks-cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}




#Creating the ACR

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.Resource-Group.name
  location            = azurerm_resource_group.Resource-Group.location
  sku                 = "Premium"
  admin_enabled       = false

}



#Creating the AKS Cluster

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = var.cluster_name
  kubernetes_version = var.kubernetes_version
  location            = azurerm_resource_group.Resource-Group.location
  resource_group_name = azurerm_resource_group.Resource-Group.name
  dns_prefix          = var.cluster_name



default_node_pool {
    name                = "system"
    node_count          = var.system_node_count
    vm_size             = "Standard_DS2_v2"
    type                = "VirtualMachineScaleSets"
    # availability_zones  = [1, 2, 3]
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"  #depends on serviceprinciple
  }

  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "kubenet" # azure (CNI)
  }
}
  