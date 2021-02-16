resource "azurerm_resource_group" "lab_rg" {
  name     = var.rg_name
  location = var.az_location
}

module "common_net" {
  source               = "./modules/common/network/"
  rg_name              = var.rg_name
  az_location          = var.az_location
  vnet_obj             = var.vnet_obj
  subnet_backend_obj   = var.subnet_backend_obj
  subnet_frontend_obj  = var.subnet_frontend_obj
  subnet_mgmt_obj      = var.subnet_mgmt_obj
  subnet_internal1_obj = var.subnet_internal1_obj
  subnet_internal2_obj = var.subnet_internal2_obj
  subnet_internal3_obj = var.subnet_internal3_obj
  depends_on           = [azurerm_resource_group.lab_rg]
}

module "cp_mgmt" {
  source = "./modules/management/"

  #Variables

  subscription_id            = var.subscription_id
  rg_name                    = var.rg_name
  subnet_mgmt_id             = module.common_net.subnet_mgmt_id
  az_location                = var.az_location
  admin_username             = var.admin_username
  admin_password             = var.admin_password
  admin_public_key_file_path = var.admin_public_key_file_path
  vnet_name                  = var.vnet_obj.name
  vnet_cidr                  = [var.vnet_obj.cidr]
  cp_mgmt_obj                = var.cp_mgmt_obj
  #This line is ugly - can be fixed with templatefile
  cloud_config_string = base64encode("#!/usr/bin/python3 /etc/cloud_config.py\n\ninstallationType=\"management\"\nallowUploadDownload=\"true\"\nosVersion=\"r8040\"\ntemplateName=\"management\"\nisBlink=\"false\"\ntemplateVersion=\"20201109\"\nbootstrapScript64=\"\"\nlocation=\"${var.az_location}\"\nmanagementGUIClientNetwork=\"0.0.0.0/0\"\n")
  depends_on          = [azurerm_resource_group.lab_rg, module.common_net]
}

module "cp_gateway" {
  source = "./modules/gateways"

  #Variables

  admin_username      = var.admin_username
  admin_password      = var.admin_password
  cp_gateway_obj      = var.cp_gateway_obj
  subscription_id     = var.subscription_id
  tenant_id           = var.tenant_id
  az_location         = var.az_location
  rg_name             = var.rg_name
  subnet_frontend_obj = var.subnet_frontend_obj
  subnet_backend_obj  = var.subnet_backend_obj
  subnet_frontend_id  = module.common_net.subnet_frontend_id
  subnet_backend_id   = module.common_net.subnet_backend_id
  subnet_internal1_id = module.common_net.subnet_internal1_id
  subnet_internal2_id = module.common_net.subnet_internal2_id
  subnet_internal3_id = module.common_net.subnet_internal3_id
  vnet_obj            = var.vnet_obj
  depends_on          = [azurerm_resource_group.lab_rg, module.common_net]
}

module "testhosts" {
  source              = "./modules/extras"
  subnet_internal1_id = module.common_net.subnet_internal1_id
  subnet_internal2_id = module.common_net.subnet_internal2_id
  subnet_internal3_id = module.common_net.subnet_internal3_id
  az_location         = var.az_location
  rg_name             = var.rg_name
  admin_password      = var.admin_password
}
