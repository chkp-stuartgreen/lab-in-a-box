
resource "azurerm_virtual_network" "lab_vnet" {
  name                = local.vnet_obj.name
  address_space       = [local.vnet_obj.cidr]
  location            = local.az_location
  resource_group_name = local.rg_name
}

resource "azurerm_subnet" "subnet_mgmt" {
  name                 = local.subnet_mgmt_obj.name
  resource_group_name  = local.rg_name
  virtual_network_name = local.vnet_obj.name
  address_prefixes     = [local.subnet_mgmt_obj.cidr]
  depends_on           = [azurerm_virtual_network.lab_vnet]
}

resource "azurerm_subnet" "subnet_frontend" {
  name                 = local.subnet_frontend_obj.name
  resource_group_name  = local.rg_name
  virtual_network_name = local.vnet_obj.name
  address_prefixes     = [local.subnet_frontend_obj.cidr]
  depends_on           = [azurerm_virtual_network.lab_vnet]
}

resource "azurerm_subnet" "subnet_backend" {
  name                 = local.subnet_backend_obj.name
  resource_group_name  = local.rg_name
  virtual_network_name = local.vnet_obj.name
  address_prefixes     = [local.subnet_backend_obj.cidr]
  depends_on           = [azurerm_virtual_network.lab_vnet]
}

resource "azurerm_subnet" "subnet_internal1" {
  name                 = local.subnet_internal1_obj.name
  resource_group_name  = local.rg_name
  virtual_network_name = local.vnet_obj.name
  address_prefixes     = [local.subnet_internal1_obj.cidr]
  depends_on           = [azurerm_virtual_network.lab_vnet]
}

resource "azurerm_subnet" "subnet_internal2" {
  name                 = local.subnet_internal2_obj.name
  resource_group_name  = local.rg_name
  virtual_network_name = local.vnet_obj.name
  address_prefixes     = [local.subnet_internal2_obj.cidr]
  depends_on           = [azurerm_virtual_network.lab_vnet]
}

resource "azurerm_subnet" "subnet_internal3" {
  name                 = local.subnet_internal3_obj.name
  resource_group_name  = local.rg_name
  virtual_network_name = local.vnet_obj.name
  address_prefixes     = [local.subnet_internal3_obj.cidr]
  depends_on           = [azurerm_virtual_network.lab_vnet]
}

