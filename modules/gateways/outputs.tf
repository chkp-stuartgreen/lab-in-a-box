output "gateway_1_address" {
  value = "${azurerm_public_ip.public-ip[0].name} - ${azurerm_public_ip.public-ip[0].ip_address}"
}
output "gateway_2_address" {
  value = "${azurerm_public_ip.public-ip[1].name} - ${azurerm_public_ip.public-ip[1].ip_address}"
}
