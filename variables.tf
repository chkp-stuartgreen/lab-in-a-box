# Variable definitions

# NOTE - subscription_id and admin_password are required
# but deliberately not set here to avoid saving sensitive
# data in any public repositories!
# Please set them as environment variables named
#
# TF_VAR_admin_password and TF_VAR_subscription_id

# Resource group name

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}
variable "rg_name" {
  type = string
}

# Location
variable "az_location" {
  type = string
}

# VNet
variable "vnet_obj" {
  type = object({
    name = string
    cidr = string
  })
}


# Subnets
# We need a few of these for the lab
# > Frontend and Backend: to attach the cluster internal and external NICs to
# > Management: somewhere for the management server to live
# > Internal1 - 3: general purpose subnets for placing hosts


variable "subnet_mgmt_obj" {
  type = object({
    name = string
    cidr = string
  })
}

variable "subnet_frontend_obj" {
  type = object({
    name = string
    cidr = string
  })
}

variable "subnet_backend_obj" {
  type = object({
    name = string
    cidr = string
  })
}

variable "subnet_internal1_obj" {
  type = object({
    name = string
    cidr = string
  })
}

variable "subnet_internal2_obj" {
  type = object({
    name = string
    cidr = string
  })
}

variable "subnet_internal3_obj" {
  type = object({
    name = string
    cidr = string
  })
}


# Check Point Management server config options
variable "cp_mgmt_obj" {
  type = object({
    osversion = string
    name      = string
    #cloud_config_string = string
  })
}

# Check Point Gateway server config options
variable "cp_gateway_obj" {
  type = object({
    osversion = string
    name      = string
    #cloud_config_string = string
    delete_os_disk_on_termination = bool
    offer : string
    publisher : string
    sku : string
    version : string
    frontend_IP_addresses : list(number)
    backend_IP_addresses : list(number)
    vm_size : string
    sickey : string
  })
}

# Used for creating the host - but not used by Gaia OS
variable "admin_username" {
  type    = string
  default = "notused"
}

variable "admin_password" {
  type = string
}

variable "admin_public_key_file_path" {
  type        = string
  description = "Path to public key file for authentication. If provided, will disable interactive auth"
  default     = ""
}

