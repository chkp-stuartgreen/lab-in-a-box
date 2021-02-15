resource "azurerm_network_interface" "hostvmnic" {
  name = "hostvmnic${count.index+1}"
  location = local.az_location
  resource_group_name = local.rg_name
  count = 3

  ip_configuration {
    name = "internalNIC"
    subnet_id = local.subnetlist[count.index]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "testhost" {
  name = "testhost${count.index+1}"
  location = local.az_location
  resource_group_name = local.rg_name
  count = 3
  size = "Standard_B2s"
  admin_username = "sysadmin"
  admin_password = var.admin_password
  network_interface_ids = [ azurerm_network_interface.hostvmnic[count.index].id ]
  disable_password_authentication = false
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}