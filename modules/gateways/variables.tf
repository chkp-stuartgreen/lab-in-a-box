
//********************** Virtual Machine Instances Variables **************************//

variable "availability_type" {
  description = "Specifies whether to deploy the solution based on Azure Availability Set or based on Azure Availability Zone."
  type = string
  default = "Availability Zone"
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "rg_name" {
  type = string
}

locals { // locals for 'availability_type' allowed values
  availability_type_allowed_values = [
    "Availability Zone",
    "Availability Set"
  ]
  // will fail if [var.availability_type] is invalid:
  validate_availability_type_value = index(local.availability_type_allowed_values, var.availability_type)
}

#resource "null_resource" "sic_key_invalid" {
#  count = length(var.sic_key) >= 12 ? 0 : "SIC key must be at least 12 characters long"
#}

variable "template_name" {
  description = "Template name. Should be defined according to deployment type(ha, vmss)"
  type = string
  default = "ha_terraform"
}

variable "template_version" {
  description = "Template version. It is reccomended to always use the latest template version"
  type = string
  default = "20210111"
}

variable "installation_type" {
  description = "Installaiton type"
  type = string
  default = "cluster"
}

variable "number_of_vm_instances" {
  description = "Number of VM instances to deploy "
  type = string
  default = "2"
}

variable "authentication_type" {
  description = "Specifies whether a password authentication or SSH Public Key authentication should be used"
  type = string
  default = "Password"
}
locals { // locals for 'authentication_type' allowed values
  authentication_type_allowed_values = [
    "Password",
    "SSH Public Key"
  ]
  // will fail if [var.authentication_type] is invalid:
  validate_authentication_type_value = index(local.authentication_type_allowed_values, var.authentication_type)
}

variable "allow_upload_download" {
  description = "Automatically download Blade Contracts and other important data. Improve product experience by sending data to Check Point"
  type = bool
  default = true
}

variable "is_blink" {
  description = "Define if blink image is used for deployment"
  default = false
}

variable "vnet_allocation_method" {
  description = "IP address allocation method"
  type = string
  default = "Static"
}

variable "lb_probe_name" {
  description = "Name to be used for lb health probe"
  default = "health_prob_port"
}

variable "lb_probe_port" {
  description = "Port to be used for load balancer health probes and rules"
  default = "8117"
}

variable "lb_probe_protocol" {
  description = "Protocols to be used for load balancer health probes and rules"
  default = "tcp"
}

variable "lb_probe_unhealthy_threshold" {
  description = "Number of times load balancer health probe has an unsuccessful attempt before considering the endpoint unhealthy."
  default = 2
}

variable "lb_probe_interval" {
  description = "Interval in seconds load balancer health probe rule perfoms a check"
  default = 5
}

variable "bootstrap_script" {
  description = "An optional script to run on the initial boot"
  #example:
  #"touch /home/admin/bootstrap.txt; echo 'hello_world' > /home/admin/bootstrap.txt"
  default = ""
  type = string
}

//********************** Credentials **************************//
variable "tenant_id" {
  description = "Tenant ID"
  type = string
}

variable "subscription_id" {
  description = "Subscription ID"
  type = string
}

variable "sku" {
  description = "SKU"
  type = string
  default = "Standard"
}

variable "enable_custom_metrics" {
  description = "Indicates whether CloudGuard Metrics will be use for Cluster members monitoring."
  type = bool
  default = true
}

variable "cp_gateway_obj" {
  type = object({
    osversion = string
    name = string
    #cloud_config_string = string
    delete_os_disk_on_termination = bool
    offer: string
    publisher: string
    sku: string
    version: string
    frontend_IP_addresses: list(number)
    backend_IP_addresses: list(number)
    vm_size: string
    sickey: string
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

variable "vnet_obj" {
  type = object({
    name = string
    cidr = string
  })
}

variable "az_location" {
  type = string
}

variable "subnet_frontend_id" {
  type = string
}

variable "subnet_backend_id" {
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