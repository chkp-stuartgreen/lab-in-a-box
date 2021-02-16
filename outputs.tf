output "management_public_ip" {
  description = "Public IP for Check Point Security Management Server"
  value       = module.cp_mgmt.public_ip_address
}

output "gateway_1_address" {
  description = "Check Point HA member 1 public IP"
  value       = module.cp_gateway.gateway_1_address
}

output "gateway_2_address" {
  description = "Check Point HA member 2 public IP"
  value       = module.cp_gateway.gateway_2_address
}

output "testhostnames" {
  value = module.testhosts.hostvmname
}

output "testhostaddresses" {
  value = module.testhosts.hostvmIPs
}
