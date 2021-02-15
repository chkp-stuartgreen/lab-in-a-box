# Variable values

az_location = "westeurope"
rg_name = "CPLabRG"

# Networking

vnet_obj = {
  name = "LabVNet"
  cidr = "10.100.0.0/16"
}

subnet_mgmt_obj = {
  name = "subnetManagement"
  cidr = "10.100.0.0/24"
}

subnet_frontend_obj = {
  name = "subnetFrontend"
  cidr = "10.100.10.0/24"
}

subnet_backend_obj = {
  name = "subnetBackend"
  cidr = "10.100.20.0/24"
}

subnet_internal1_obj = {
  name = "subnetInternal1"
  cidr = "10.100.101.0/24"
}

subnet_internal2_obj = {
  name = "subnetInternal2"
  cidr = "10.100.102.0/24"
}

subnet_internal3_obj = {
  name = "subnetInternal3"
  cidr = "10.100.103.0/24"
}

## End Networking
cp_mgmt_obj = {
  osversion = "R8040"
  name = "CPLabSecurityManagement"
  # Think this needs to be a file - but not until we can dynamicly
  # populate the region :(
  #cloud_config_string = "#!/usr/bin/python3 /etc/cloud_config.py\n\ninstallationType=\"management\"\nallowUploadDownload=\"true\"\nosVersion=\"r8040\"\ntemplateName=\"management\"\nisBlink=\"false\"\ntemplateVersion=\"20201109\"\nbootstrapScript64=\"\"\nlocation=\"${var.az_location}\"\nmanagementGUIClientNetwork=\"0.0.0.0/0\"\n"
}

cp_gateway_obj = {
  name = "CPLabGateway"
  osversion = "R8040"
  sku = "sg-byol"
  frontend_IP_addresses = [5,6,7]
  backend_IP_addresses = [5,6,7]
  delete_os_disk_on_termination = true
  publisher = "checkpoint"
  offer = "check-point-cg-r8040"
  version = "latest"
  sickey = "vpn123vpn123"
  vm_size = "Standard_D2_v2"
  }

