## This template creates on Vnet and two subnets (public and private) and vm
# Generate Random resource_group name
# resource "random_pet" "rg_name" {
#   prefix = var.resource_group_name_prefix
# }

# Create Resource Group
resource "azurerm_resource_group" "rg" {
  location = "${var.resource_group_location}"
  name     = var.resource_group_name_prefix
}

# Create virtual network
resource "azurerm_virtual_network" "vnet_work" {
  name                = "Vnet-${azurerm_resource_group.rg.location}"
  address_space       = ["${var.vnet_cidr}"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create public subnet
resource "azurerm_subnet" "vnet_public_subnet" {
  name                 = var.vnet_config["public_subnet"]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_work.name
  address_prefixes     = ["${var.public_subnet_address}"]
}

# Create private subnet
resource "azurerm_subnet" "vnet_private_subnet" {
  name                 = var.vnet_config["private_subnet"]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet_work.name
  address_prefixes     = ["${var.private_subnet_address}"]
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "SecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

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
  security_rule {
    name                       = "InternetAccess"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "RDP"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# # Create public IPs
# resource "azurerm_public_ip" "public_ip" {
#   name                = "PublicIp"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   allocation_method   = "Dynamic"
# }
# # Create network interface
# resource "azurerm_network_interface" "public_nic" {
#   name                = "NIC"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "nic_config"
#     subnet_id                     = azurerm_subnet.vnet_public_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.public_ip.id
#   }
# }

# # Connect the security group to the network interface (NIC)
# resource "azurerm_network_interface_security_group_association" "connect_nsg_to_nic" {
#   network_interface_id      = azurerm_network_interface.public_nic.id
#   network_security_group_id = azurerm_network_security_group.nsg.id
# }

# --- linux vm ---

# resource "azurerm_public_ip" "pip" {
#   name                = "${var.vm_name}-pip"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   allocation_method   = "Dynamic"
# }

resource "azurerm_network_interface" "vm_nic" {
  name                = "${var.vm_name}-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  enable_ip_forwarding = true
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnet_private_subnet.id
    private_ip_address_allocation = "Dynamic"
    # enable ip forwarding

    # public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                            = var.vm_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                            = "Standard_B1s"
  admin_username                  = var.user
  admin_password                  = var.pass
  disable_password_authentication = false
  computer_name                   = var.vm_name
  network_interface_ids           = [azurerm_network_interface.vm_nic.id]
  # depends_on                      = [azurerm_public_ip.pip]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  boot_diagnostics {
    # enabled     = true
   storage_account_uri = null
  }

# provisioner "file" {
#   source      = "./modules/script.sh"
#   destination = "/tmp/script.sh"

# connection {
#   host      = self.public_ip_address
#   user      = self.admin_username
#   password  = self.admin_password
#   }
#  }

# provisioner "local-exec" {
#   command = "echo ${azurerm_linux_virtual_machine.vm.public_ip_address} >> ip.txt"
# }

# provisioner "remote-exec" {
#   inline = [ 
#     "ls -la /tmp",
#     # "chmod 777 /tmp/script.sh",
#     # "./tmp/script.sh >> result.txt"
#    ]
# connection {
#   host      = self.public_ip_address
#   user      = self.admin_username
#   password  = self.admin_password
#   }
# }

}





# data "azurerm_public_ip" "pip" {
#   name                = azurerm_public_ip.pip.name
#   resource_group_name = azurerm_resource_group.rg.name
#   depends_on          = [azurerm_linux_virtual_machine.vm]
# }


# data "azurerm_client_config" "current" {}

resource "azurerm_virtual_network_peering" "vnet2_to_hub" {
    name                         = "vnet1-to-hub"
    resource_group_name          = azurerm_resource_group.rg.name
    virtual_network_name         = azurerm_virtual_network.vnet_work.name
    remote_virtual_network_id    = var.hub_vnet_id
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = true
    }

# Create a route table in the vnet2 spoke network

resource "azurerm_route_table" "vnet2_route_table" {
  name                = "vnet2_route_table"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  route {
    name                   = "vnet2_route_table"
    address_prefix         = "10.2.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.1.2.4"
}
}

# # associate the route table with the subnet
resource "azurerm_subnet_route_table_association" "vnet2_subnet_association" {
  subnet_id      = azurerm_subnet.vnet_private_subnet.id
  route_table_id = azurerm_route_table.vnet2_route_table.id
}