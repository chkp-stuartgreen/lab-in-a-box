variable "subscription_id" {
  type      = string
  sensitive = true
}

variable "subnet_mgmt_id" {
  type = string
}

variable "cp_mgmt_obj" {
  type = object({
    name      = string
    osversion = string
  })
}

variable "az_location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_cidr" {
  type = list(string)
}

variable "rg_name" {
  type = string
}

#variable "cp_osversion" {
#    type = string
#    default = "R8040"
#}

#variable "log_server_name" {
#  type = string
#}


variable "admin_password" {
  type      = string
  sensitive = true
}

variable "admin_username" {
  type = string

}

#variable "custom_data" {
#  type = string
#}

#"imagePublisher": "checkpoint",
#        "imageReferenceBYOL": {
#            "offer": "[variables('imageOffer')]",
#            "publisher": "[variables('imagePublisher')]",
#            "sku": "mgmt-byol",
#            "version": "latest"
#        },


variable "cloud_config_string" {
  type = string
}

variable "admin_public_key_file_path" {
  type        = string
  description = "Path to public key file for authentication. If provided, will disable interactive auth"
  default     = ""
}

