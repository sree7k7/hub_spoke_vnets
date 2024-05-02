


module "module_vnet1" {
  source = "./vnet1_modules"
#   prefix = "development"
  vnet_cidr = "10.2.0.0/16"
  public_subnet_address = "10.2.1.0/24"
  private_subnet_address = "10.2.2.0/24"
  resource_group_location = "northeurope"
  resource_group_name_prefix = "vnet1_rg"
  hub_vnet_id = module.module_hub.vnet_id
}

module "module_vnet2" {
  source = "./vnet2_modules"
#   prefix = "development"
  vnet_cidr = "10.3.0.0/16"
  public_subnet_address = "10.3.1.0/24"
  private_subnet_address = "10.3.2.0/24"
  resource_group_location = "westeurope"
  resource_group_name_prefix = "vnet2_rg"
}   

module "module_hub" {
  source = "./hub_modules"
#   prefix = "development"
  vnet_cidr = "10.1.0.0/16"
  public_subnet_address = "10.1.1.0/24"
  private_subnet_address = "10.1.2.0/24"
  resource_group_location = "centralindia"
  resource_group_name_prefix = "hub_rg"
  vnet1_id = module.module_vnet1.vnet_id
  vnet2_id = module.module_vnet2.vnet_id
}