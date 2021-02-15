//********************** Networking **************************//


resource "azurerm_public_ip" "public-ip" {
  count = 2
  name = "${local.cp_gateway_obj.name}${count.index+1}_IP"
  location = local.az_location
  resource_group_name = local.rg_name
  allocation_method = var.vnet_allocation_method
  sku = var.sku
}

resource "azurerm_public_ip" "cluster-vip" {
  name = local.cp_gateway_obj.name
  location = local.az_location
  resource_group_name = local.rg_name
  allocation_method = var.vnet_allocation_method
  sku = var.sku
}

resource "azurerm_network_interface" "nic_vip" {
  depends_on = [
    azurerm_public_ip.cluster-vip,
    azurerm_public_ip.public-ip]
  name = "${local.cp_gateway_obj.name}1-eth0"
  location = local.az_location
  resource_group_name = local.rg_name
  enable_ip_forwarding = true
  enable_accelerated_networking = true

  ip_configuration {
    name = "ipconfig1"
    primary = true
    subnet_id = local.subnet_frontend_id
    private_ip_address_allocation = var.vnet_allocation_method
    private_ip_address = cidrhost(local.subnet_frontend_obj.cidr, local.cp_gateway_obj.frontend_IP_addresses[0])
    public_ip_address_id = azurerm_public_ip.public-ip.0.id
  }
  ip_configuration {
    name = "cluster-vip"
    subnet_id = local.subnet_frontend_id
    primary = false
    private_ip_address_allocation = var.vnet_allocation_method
    private_ip_address = cidrhost(local.subnet_frontend_obj.cidr, local.cp_gateway_obj.frontend_IP_addresses[2])
    public_ip_address_id = azurerm_public_ip.cluster-vip.id
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to ip_configuration when Re-applying, e.g. because a cluster failover and associating the cluster- vip with the other member.
      # updates these based on some ruleset managed elsewhere.
      ip_configuration
    ]
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_vip_lb_association" {
  depends_on = [azurerm_network_interface.nic_vip, azurerm_lb_backend_address_pool.frontend-lb-pool]
  network_interface_id    = azurerm_network_interface.nic_vip.id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.frontend-lb-pool.id
}

resource "azurerm_network_interface" "nic" {
  depends_on = [
    azurerm_public_ip.public-ip,
    azurerm_lb.frontend-lb]
  name = "${local.cp_gateway_obj.name}2-eth0"
  location = local.az_location
  resource_group_name = local.rg_name
  enable_ip_forwarding = true
  enable_accelerated_networking = true

  ip_configuration {
    name = "ipconfig1"
    primary = true
    subnet_id = local.subnet_frontend_id
    private_ip_address_allocation = var.vnet_allocation_method
    private_ip_address = cidrhost(local.subnet_frontend_obj.cidr, local.cp_gateway_obj.frontend_IP_addresses[1])
    public_ip_address_id = azurerm_public_ip.public-ip.1.id
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to ip_configuration when Re-applying, e.g. because a cluster failover and associating the cluster- vip with the other member.
      # updates these based on some ruleset managed elsewhere.
      ip_configuration
    ]
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_lb_association" {
  depends_on = [azurerm_network_interface.nic, azurerm_lb_backend_address_pool.frontend-lb-pool]
  network_interface_id    = azurerm_network_interface.nic.id
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = azurerm_lb_backend_address_pool.frontend-lb-pool.id
}

resource "azurerm_network_interface" "nic1" {
  depends_on = [
    azurerm_lb.backend-lb]
  count = 2
  name = "${local.cp_gateway_obj.name}${count.index+1}-eth1"
  location = local.az_location
  resource_group_name = local.rg_name
  enable_ip_forwarding = true
  enable_accelerated_networking = true

  ip_configuration {
    name = "ipconfig2"
    subnet_id = local.subnet_backend_id
    private_ip_address_allocation = var.vnet_allocation_method
    private_ip_address = cidrhost(local.subnet_backend_obj.cidr, local.cp_gateway_obj.backend_IP_addresses[count.index+1])
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "nic1_lb_association" {
  depends_on = [azurerm_network_interface.nic1, azurerm_lb_backend_address_pool.backend-lb-pool]
  count = 2
  network_interface_id    = azurerm_network_interface.nic1[count.index].id
  ip_configuration_name   = "ipconfig2"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend-lb-pool.id
}

//********************** Load Balancers **************************//
resource "azurerm_public_ip" "public-ip-lb" {
  name = "frontend_lb_ip"
  location = local.az_location
  resource_group_name = local.rg_name
  allocation_method = var.vnet_allocation_method
  sku = var.sku
}

resource "azurerm_lb" "frontend-lb" {
  depends_on = [
    azurerm_public_ip.public-ip-lb]
  name = "frontend-lb"
  location = local.az_location
  resource_group_name = local.rg_name
  sku = var.sku

  frontend_ip_configuration {
    name = "LoadBalancerFrontend"
    public_ip_address_id = azurerm_public_ip.public-ip-lb.id
  }
}

resource "azurerm_lb_backend_address_pool" "frontend-lb-pool" {
  resource_group_name = local.rg_name
  loadbalancer_id = azurerm_lb.frontend-lb.id
  name = "frontend-lb-pool"
}

resource "azurerm_lb" "backend-lb" {
  name = "backend-lb"
  location = local.az_location
  resource_group_name = local.rg_name
  sku = var.sku
  frontend_ip_configuration {
    name = "backend-lb"
    subnet_id = local.subnet_backend_id
    private_ip_address_allocation = var.vnet_allocation_method
    private_ip_address = cidrhost(local.subnet_backend_obj.cidr, var.cp_gateway_obj.backend_IP_addresses[0])
  }
}

resource "azurerm_lb_backend_address_pool" "backend-lb-pool" {
  name = "backend-lb-pool"
  loadbalancer_id = azurerm_lb.backend-lb.id
  resource_group_name = local.rg_name
}

resource "azurerm_lb_probe" "azure_lb_healprob" {
  count = 2
  resource_group_name = local.rg_name
  loadbalancer_id = count.index == 0 ? azurerm_lb.frontend-lb.id : azurerm_lb.backend-lb.id
  name = var.lb_probe_name
  protocol = var.lb_probe_protocol
  port = var.lb_probe_port
  interval_in_seconds = var.lb_probe_interval
  number_of_probes = var.lb_probe_unhealthy_threshold
}

//********************** Availability Set **************************//
locals {
  availability_set_condition = var.availability_type == "Availability Set" ? true : false
  SSH_authentication_type_condition = var.authentication_type == "SSH Public Key" ? true : false
}
resource "azurerm_availability_set" "availability-set" {
  count = local.availability_set_condition ? 1 : 0
  name = "${local.cp_gateway_obj.name}-AvailabilitySet"
  location = local.az_location
  resource_group_name = local.rg_name
  platform_fault_domain_count = 2
  platform_update_domain_count = 5
  managed = true
}

//********************** Storage accounts **************************//
// Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = local.rg_name
  }
  byte_length = 8
}
resource "azurerm_storage_account" "vm-boot-diagnostics-storage" {
  name = "bootdiag${random_id.randomId.hex}"
  resource_group_name = local.rg_name
  location = local.az_location
  account_tier = local.storage_account_tier
  account_replication_type = local.account_replication_type
}

//********************** Virtual Machines **************************//
resource "azurerm_virtual_machine" "vm-instance-availability-set" {
  depends_on = [
    azurerm_network_interface.nic,
    azurerm_network_interface.nic1,
    azurerm_network_interface.nic_vip]
  count = 2
  name = "${local.cp_gateway_obj.name}${count.index+1}"
  location = local.az_location
  resource_group_name = local.rg_name
  availability_set_id = local.availability_set_condition ? azurerm_availability_set.availability-set[0].id : ""
  vm_size = local.cp_gateway_obj.vm_size
  network_interface_ids = count.index == 0 ? [
    azurerm_network_interface.nic_vip.id,
    azurerm_network_interface.nic1.0.id] : [
    azurerm_network_interface.nic.id,
    azurerm_network_interface.nic1.1.id]
  delete_os_disk_on_termination = local.cp_gateway_obj.delete_os_disk_on_termination
  primary_network_interface_id = count.index == 0 ? azurerm_network_interface.nic_vip.id : azurerm_network_interface.nic.id
  identity {
    type = "SystemAssigned"
  }
  storage_image_reference {
    publisher = local.cp_gateway_obj.publisher
    offer = local.cp_gateway_obj.offer
    sku = local.cp_gateway_obj.sku
    version = local.cp_gateway_obj.version
  }

  storage_os_disk {
    name = "${local.cp_gateway_obj.name}-${count.index+1}"
    create_option = "FromImage"
    caching = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    disk_size_gb = "100"
  }

  plan {
    name = local.cp_gateway_obj.sku
    publisher = local.cp_gateway_obj.publisher
    product = local.cp_gateway_obj.offer
  }

  os_profile {
    computer_name = "${local.cp_gateway_obj.name}${count.index+1}"
    admin_username = local.admin_username
    admin_password = local.admin_password
    custom_data = templatefile("${path.module}/cloud-init.sh", {
      installation_type = "cluster"
      allow_upload_download = true
      os_version = "R80.40"
      template_name = "ha"
      template_version = "ha"
      is_blink = false
      bootstrap_script64 = base64encode(var.bootstrap_script)
      location = local.az_location
      sic_key = local.cp_gateway_obj.sickey
      tenant_id = local.tenant_id
      virtual_network = local.vnet_obj.name
      cluster_name = local.cp_gateway_obj.name
      external_private_addresses = azurerm_network_interface.nic_vip.ip_configuration[1].private_ip_address
      enable_custom_metrics= "yes"
    })
  }

  os_profile_linux_config {
    disable_password_authentication = local.SSH_authentication_type_condition

    dynamic "ssh_keys" {
      for_each = local.SSH_authentication_type_condition ? [
        1] : []
      content {
        path = "/home/notused/.ssh/authorized_keys"
        key_data = file("./azure_public_key")
      }
    }
  }

  boot_diagnostics {
    enabled = true
    storage_uri = join(",", azurerm_storage_account.vm-boot-diagnostics-storage.*.primary_blob_endpoint)
  }
}

resource "azurerm_virtual_machine" "vm-instance-availability-zone" {
  depends_on = [
    azurerm_network_interface.nic,
    azurerm_network_interface.nic1,
    azurerm_network_interface.nic_vip]
  count = 0
  name = "${local.cp_gateway_obj.name}${count.index+1}"
  location = local.az_location
  resource_group_name = local.rg_name
  zones = [
    count.index+1]
  vm_size = "Standard_D2_v2"
  network_interface_ids = count.index == 0 ? [
    azurerm_network_interface.nic_vip.id,
    azurerm_network_interface.nic1.0.id] : [
    azurerm_network_interface.nic.id,
    azurerm_network_interface.nic1.1.id]
  delete_os_disk_on_termination = true
  primary_network_interface_id = count.index == 0 ? azurerm_network_interface.nic_vip.id : azurerm_network_interface.nic.id
  identity {
    type = "SystemAssigned"
  }
  storage_image_reference {
    publisher = local.cp_gateway_obj.publisher
    offer = local.cp_gateway_obj.offer
    sku = local.cp_gateway_obj.sku
    version = local.cp_gateway_obj.version
  }

  storage_os_disk {
    name = "${local.cp_gateway_obj.name}-${count.index+1}"
    create_option = "FromImage"
    caching = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    disk_size_gb = "100"
  }

  plan {
    name = local.cp_gateway_obj.sku
    publisher = local.cp_gateway_obj.publisher
    product = local.cp_gateway_obj.offer
  }

  os_profile {
    computer_name = "${local.cp_gateway_obj.name}${count.index+1}"
    admin_username = local.admin_username
    admin_password = local.admin_password
    custom_data = templatefile("${path.module}/cloud-init.sh", {
      installation_type = "cluster"
      allow_upload_download = true
      os_version = "R80.40"
      template_name = "ha"
      template_version = "ha"
      is_blink = false
      bootstrap_script64 = base64encode(var.bootstrap_script)
      location = local.az_location
      sic_key = local.cp_gateway_obj.sickey
      tenant_id = local.tenant_id
      virtual_network = local.vnet_obj.name
      cluster_name = local.cp_gateway_obj.name
      external_private_addresses = azurerm_network_interface.nic_vip.ip_configuration[1].private_ip_address
      enable_custom_metrics= "yes"
    })
  }

  os_profile_linux_config {
    disable_password_authentication = local.SSH_authentication_type_condition

    dynamic "ssh_keys" {
      for_each = local.SSH_authentication_type_condition ? [
        1] : []
      content {
        path = "/home/notused/.ssh/authorized_keys"
        key_data = file("./azure_public_key")
      }
    }
  }

  boot_diagnostics {
    enabled = true
    storage_uri = join(",", azurerm_storage_account.vm-boot-diagnostics-storage.*.primary_blob_endpoint)
  }
}
//********************** Role Assigments **************************//
data "azurerm_role_definition" "role_definition" {
  name = "Contributor"
}
data "azurerm_client_config" "client_config" {
}
resource "azurerm_role_assignment" "cluster_assigment" {
  count = 2
  lifecycle {
    ignore_changes = [
      role_definition_id, principal_id
    ]
  }
  scope = "/subscriptions/${local.subscription_id}"
  role_definition_id = data.azurerm_role_definition.role_definition.id
  #principal_id = local.availability_set_condition ? lookup(azurerm_virtual_machine.vm-instance-availability-set[count.index].identity[0], "principal_id") : lookup(azurerm_virtual_machine.vm-instance-availability-zone[count.index].identity[0], "principal_id")
  principal_id = lookup(azurerm_virtual_machine.vm-instance-availability-set[count.index].identity[0], "principal_id")
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc_gw" {
  subnet_id                 = local.subnet_frontend_id
  network_security_group_id = azurerm_network_security_group.nsg_gw.id
}

resource "azurerm_network_security_group" "nsg_gw" {
  name = "gw_nsg"
  location = local.az_location
  resource_group_name = local.rg_name

}


resource "azurerm_network_security_rule" "gw_nsg_rule_inbound_allow" {
  name = "gw_nsg_inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = local.rg_name
  network_security_group_name = azurerm_network_security_group.nsg_gw.name
}

resource "azurerm_route_table" "rt_internal_subnets" {
  name = "routeTableViaGateways"
  location = local.az_location
  resource_group_name = local.rg_name
  route {
    name = "toGateway"
    address_prefix = "0.0.0.0/0"
    next_hop_type = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_lb.backend-lb.private_ip_address
  }

}

resource "azurerm_subnet_route_table_association" "internal1_rt_assoc" {
  subnet_id = local.subnet_internal1_id
  route_table_id = azurerm_route_table.rt_internal_subnets.id
}

resource "azurerm_subnet_route_table_association" "internal2_rt_assoc" {
  subnet_id = local.subnet_internal2_id
  route_table_id = azurerm_route_table.rt_internal_subnets.id
}
