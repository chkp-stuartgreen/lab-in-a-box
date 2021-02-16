locals {
  rg_name                  = var.rg_name
  tenant_id                = var.tenant_id
  subscription_id          = var.subscription_id
  az_location              = var.az_location
  vnet_obj                 = var.vnet_obj
  subnet_backend_obj       = var.subnet_backend_obj
  subnet_frontend_obj      = var.subnet_frontend_obj
  cp_gateway_obj           = var.cp_gateway_obj
  subnet_frontend_id       = var.subnet_frontend_id
  subnet_backend_id        = var.subnet_backend_id
  admin_username           = var.admin_username
  admin_password           = var.admin_password
  storage_account_tier     = "Standard"
  account_replication_type = "LRS"
  subnet_internal1_id      = var.subnet_internal1_id
  subnet_internal2_id      = var.subnet_internal2_id
  subnet_internal3_id      = var.subnet_internal3_id
}
