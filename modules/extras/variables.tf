variable "az_location" {
  type = string
}

variable "rg_name" {
  type = string
}

variable "subnet_internal1_id" {
  type = string
}

variable "subnet_internal2_id" {
  type = string
}

variable "subnet_internal3_id" {
  type = string
}

#variable "subnetlist" {
#  type = list(string)
#}

variable "admin_password" {
  type = string
  sensitive = true
}