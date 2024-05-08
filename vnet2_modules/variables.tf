variable "resource_group_location" {
  default     = "northeurope"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  default     = "vnet2_rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

# Vnet details
variable "vnet_config" {
    type = map(string)
    default = {
      public_subnet = "PublicSubnet"      
      private_subnet = "PrivateSubnet"      
    }
}
variable "vnet_cidr" {
  type = string
}

variable "public_subnet_address" {
  type = string
}

variable "private_subnet_address" {
  type = string
}


variable "vm_name" {
  type = string
  default = "ubuntu-vm2"
}

variable "user" {
  type = string
  default = "demousr"
}

variable "pass" {
  type = string
  default = "Password@143"
}

variable "hub_vnet_id" {
  type = string
}