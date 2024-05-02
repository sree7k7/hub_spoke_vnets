output "hub_vnet" {
    value = azurerm_virtual_network.vnet_work.name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet_work.id
}