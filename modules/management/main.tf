resource "azurerm_linux_virtual_machine" "cp_mgmt" {
  name                = local.cp_mgmt_name
  resource_group_name = var.rg_name
  location            = var.az_location
  size                = "Standard_D3_v2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  # If a public key is provided, we will disabled interactive authentication
  disable_password_authentication = var.admin_public_key_file_path != "" ? true : false

  network_interface_ids = [azurerm_network_interface.mgmt_nic.id]
  custom_data           = base64encode("#!/usr/bin/python3 /etc/cloud_config.py\n\ninstallationType=\"management\"\nallowUploadDownload=\"true\"\nosVersion=\"r8040\"\ntemplateName=\"management\"\nisBlink=\"false\"\ntemplateVersion=\"20201109\"\nbootstrapScript64=\"\"\nlocation=\"${var.az_location}\"\nmanagementGUIClientNetwork=\"0.0.0.0/0\"\n")
  source_image_reference {
    publisher = "checkpoint"
    offer     = "check-point-cg-r8040"
    sku       = "mgmt-byol"
    version   = "latest"
  }

  # This section will only be added if you have specified a path to your
  # public key file in the terraform.tfvars file
  dynamic "admin_ssh_key" {
    for_each = var.admin_public_key_file_path != "" ? [1] : []
    content {
      username   = "notused"
      public_key = file(var.admin_public_key_file_path)
    }
  }

  plan {
    name      = "mgmt-byol"
    product   = "check-point-cg-r8040"
    publisher = "checkpoint"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 100
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc_mgmt" {
  subnet_id                 = local.subnet_mgmt_id
  network_security_group_id = azurerm_network_security_group.nsg_mgmt.id
}
