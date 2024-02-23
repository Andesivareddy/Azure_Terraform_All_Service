variable "resource_group_name" {
    type = string
    description = "Resource_Group_Name in azure"
}

variable "resource_group_location" {
  type = string
  description = "Location in Azure"
}

variable "keyvault_name" {
  type        = string
  description = "Key Vault name in Azure"
}

variable "secret_name" {
  type        = string
  description = "Key Vault name in Azure"
}

variable "secret_vaule" {
  type        = string
  description = "Key Vault name in Azure"
  sensitive = true
}
