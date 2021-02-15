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