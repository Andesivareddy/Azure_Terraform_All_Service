variable "resource_group_name" {
    type = string
    description = "Resource_Group_Name in azure"
}

variable "resource_group_location" {
  type = string
  description = "Location in Azure"
}

variable "storage_account_name" {
  type        = string
  description = "Storage Account name in Azure"
}

variable "storage_container_name" {
  type        = string
  description = "Storage Container name in Azure"
}