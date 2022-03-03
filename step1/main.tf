// CHALLENGE:

// TODO: 
// Associate NSG with subnet
// Associate Public IP with NIC
// Associate NIC with virtual machine
// Associate route table with subnet

// READ THROUGH THE CODE CAREFULLY

//=============================================
// WRITE CONFIGS HERE:



//=============================================

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.97.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_virtual_network" "network" {
  name                = "${var.prefix}-vnet"
  location            = local.rg_location
  resource_group_name = local.rg_name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "Production"
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = local.rg_name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-nsg"
  location            = local.rg_location
  resource_group_name = local.rg_name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-nic"
  location            = local.rg_location
  resource_group_name = local.rg_name

  ip_configuration {
    name                          = "${var.prefix}-nic-config"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"

    // TODO: Associate public IP with this network interface
    // HERE
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.prefix}-public-ip"
  resource_group_name = local.rg_name
  location            = local.rg_location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.prefix}-vm"
  location              = local.rg_location
  resource_group_name   = local.rg_name

  // TODO: Associate network interface with this VM
  // HERE

  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "Production"
  }
}

resource "azurerm_route_table" "route_table" {
  name                  = "${var.prefix}-rt"
  location              = local.rg_location
  resource_group_name   = local.rg_name
  disable_bgp_route_propagation = false

  route {
    name           = "vnetlocal"
    address_prefix = "10.0.0.0/16"
    next_hop_type  = "vnetlocal"
  }

  route {
    name           = "internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }

  tags = {
    environment = "Production"
  }
}