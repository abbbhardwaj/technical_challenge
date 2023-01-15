output "public_ip" {
  description = "front end public ip created"
  value       = azurerm_public_ip.app_gw_public_ip.*
}