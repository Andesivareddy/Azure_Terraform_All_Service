resource "azurerm_resource_group" "Resource-Group" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = {
    environment = "prod"
  }
}

#Creates Virtual Network

resource "azurerm_virtual_network" "azure_Virtual_network" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Resource-Group.location
  resource_group_name = azurerm_resource_group.Resource-Group.name
}

# Creates Azure-Subnet

resource "azurerm_subnet" "azure-subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.Resource-Group.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}


# Create public IPs
resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.Resource-resource_group_location
  resource_group_name = azurerm_resource_group.Resource-Group.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "production"
  }
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group_name
  location            = azurerm_resource_group.Resource-Group.location
  resource_group_name = azurerm_resource_group.Resource-Group.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "production"
  }
}


# Creates Azure NIC

resource "azurerm_network_interface" "azure-nic" {
  name                = var.network_interface_name
  location            = azurerm_resource_group.Resource-Group.location
  resource_group_name = azurerm_resource_group.Resource-Group.name

  ip_configuration {
    name                          = "mynic"
    subnet_id                     = azurerm_subnet.azure-subnet.id
    private_ip_address_allocation = "Dynamic"
     public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.azure-nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Storage Account


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

# Storage Container

resource "azurerm_storage_container" "storage-container" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.new-storage-Account.name
  container_access_type = "container"
}

# Blob CONTAINER 

resource "azurerm_storage_blob" "blob" {
  name                   = "my-awesome-content.zip"
  storage_account_name   = azurerm_storage_account.new-storage-Account.name
  storage_container_name = azurerm_storage_container.storage-container.name
  type                   = "Block"
  source                 = "commands.sh"
}


# Creates Azure Linux VM

resource "azurerm_linux_virtual_machine" "azure_linux" {
  name                = var.linux_virtual_machine_name
  resource_group_name = azurerm_resource_group.Resource-Group.name
  location            = azurerm_resource_group.Resource-Group.location
  size                = "Standard_F2"
  #admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.azure-nic.id,
  ]

   os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  tags = {
    environment = "prod"
  }
}