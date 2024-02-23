variable "resource_group_name" {
    type = string
    description = "Resource_Group_Name in azure"
}

variable "resource_group_location" {
  type = string
  description = "Location in Azure"
}

variable "virtual_network_name" {
  type = string
  description = "creates virtual network"
}

variable "subnet_name" {
  type = string
  description = "creates subnet"
}

variable "network_interface_name" {
  type = string
  description = "creates NIC"
}

variable "linux_virtual_machine_name" {
    type = string
    description = "creates linux vm"
  
}

variable "network_security_group_name" {
    type = string
    description = "Creates NSG"  
}

variable "storage_account_name" {
  type = string
  description = "creates SA"
}

variable "storage_container_name" {
  type = string
  description = "Storage-ContainerName"
}

variable "public_ip_name" {
  type = string
  description = "creates public-ip"
}