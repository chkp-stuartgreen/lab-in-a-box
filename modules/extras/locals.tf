locals {
  az_location = var.az_location
  rg_name     = var.rg_name
  subnetlist  = [var.subnet_internal1_id, var.subnet_internal2_id, var.subnet_internal3_id]
}
