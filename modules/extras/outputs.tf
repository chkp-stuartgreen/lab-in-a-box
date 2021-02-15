output "hostvmname" {
  value = azurerm_linux_virtual_machine.testhost.*.name
}

output "hostvmIPs" {
  value = azurerm_network_interface.hostvmnic.*.ip_configuration
}