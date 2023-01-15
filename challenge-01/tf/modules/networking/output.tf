output "network_name" {
  value       = azurerm_virtual_network.vnet01.name
  description = "Name of the Virtual network"
}

output "websubnet_id" {
  value       = azurerm_subnet.web-subnet.id
  description = "Id of websubnet in the network"
}