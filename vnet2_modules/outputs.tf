output "vnet2" {
    value = azurerm_virtual_network.vnet_work.name
}

output "vnet_id" {
  value = azurerm_virtual_network.vnet_work.id
}