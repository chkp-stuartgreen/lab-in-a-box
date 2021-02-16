

resource "azurerm_public_ip" "public_ip_mgmt" {
  name                = "mgmtPublicIP"
  resource_group_name = var.rg_name
  location            = var.az_location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "mgmt_nic" {
  name                = "mgmt-eth0"
  location            = var.az_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "externalNIC"
    subnet_id                     = local.subnet_mgmt_id
    private_ip_address_version    = "IPv4"
    private_ip_address_allocation = "Dynamic"
    primary                       = true
    public_ip_address_id          = azurerm_public_ip.public_ip_mgmt.id
  }
}
