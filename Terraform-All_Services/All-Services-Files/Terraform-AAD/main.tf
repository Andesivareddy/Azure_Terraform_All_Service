# Version 2.47.0
resource "azurerm_resource_group" "Resource-Group" {
  name     = var.resource_group_name
  location = var.resource_group_location
}


# Creating the Users
resource "azuread_user" "adamc" {
 user_principal_name   = "adamc@adamrpconnellygmail.onmicrosoft.com"
 display_name          = "Adam Connelly"
 password              = "SuperSecret01@!"
 force_password_change = true
}

resource "azuread_user" "bobd" {
 user_principal_name   = "bobd@adamrpconnellygmail.onmicrosoft.com"
 display_name          = "Bob Dolton"
 password              = "SuperSecret01@!"
 force_password_change = true
}


# Create a Group for the user
resource "azuread_group" "development" {
 display_name = "Development"
 members = [
   azuread_user.adamc.id
 ]
}

resource "azuread_group" "sales" {
 display_name = "Sales"
 members = [
   azuread_user.bobd.id
 ]
}