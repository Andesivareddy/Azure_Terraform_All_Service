variable "resource_group_name" {
    type = string
    description = "Resource_Group_Name in azure"
}

variable "resource_group_location" {
  type = string
  description = "Location in Azure"
}

variable "cluster_name" {
  type = string
  description = "Creates AKS Cluster"
}

variable "kubernetes_version" {
   type = string
  description = "Creates AKS Cluster"
}

variable "system_node_count" {
  type = string
  description = "creates no of node count"
}

variable "node_resource_group" {
  type        = string
  description = "RG name for cluster resources in Azure"
}

variable "acr_name" {
  type        = string
  description = "ACR name"
}