variable "resource_group_location" {
  default     = "centralindia"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

# Vnet details
variable "vnet_config" {
    type = map(string)
    default = {
      public_subnet = "PublicSubnet"      
      private_subnet = "PrivateSubnet"
      routeserver_subnet = "RouteServerSubnet"      
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

variable "routeserver_subnet_address" {
  type = string
}

variable "vm_name" {
  type = string
  default = "ubuntu-Hub-vm"
}

variable "user" {
  type = string
  default = "demousr"
}

variable "pass" {
  type = string
  default = "Password@143"
}

variable "vnet1_id" {
  description = "The ID of the VNet1"
  type        = string
}

variable "vnet2_id" {
  description = "The ID of the VNet2"
  type        = string
}

# variable "hub_vnet_id" {
#   description = "The ID of the Hub VNet"
#   type        = string
# }