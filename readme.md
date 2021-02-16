# Check Point HA Lab-in-a-box

This is a Terraform project to build a demo / POC Check Point HA environment as quickly as possible.  
It will create...

* 2x Check Point R80.40 Gateways in HA with public IPs
* 1x Frontend load balancer
* 1x Backend load balancer
* 1x Check Point Management Server with public IP
* 3x Test hosts (Ubuntu 19.04 LTS) with private IPs, each in their own InternalX subnet

The networking elements will be...  

Network Element|Address Space
-|-
VNet|10.100.0.0/16
Management Subnet | 10.100.0.0/24
Frontend Subnet | 10.100.10.0/24
Backend Subnet | 10.100.20.0/24
Internal1 Subnet|10.100.101.0/24
Internal2 Subnet|10.100.102.0/24
Internal3 Subnet|10.100.103.0/24  


\
Internal1 and Internal2 subnets are configured with User Defined Routes (UDRs) to point to the private address of the internal load balancer for all traffic so you can easily demonstrate micro-segmentation.  
Internal3 does **NOT** have this configured.
\
When you have deployed via Terraform, you will be presented with the public IPs of each of the Check Point components.

## Instructions

1. Install and configure the Azure CLI.
1. Run `az account list` and note your subscription ID(usually shown as the first 'id' in the output) and tenant ID.
1. Define the following environment variables. Admin password will be the password used for all hosts created and needs to be 12 characters (alpha-numeric+special)
    * `TF_VAR_admin_password`
    * `TF_VAR_subscription_id`
    * `TF_VAR_tenant_id`
1. Download or clone this repository
1. Change into this directory
1. Run `terraform init`
1. Run `terraform plan` to view the proposed changes or `terraform apply` to view and then create.
1. Wait a few minutes, then you'll be given the IP addresses for all of the virtual machines created. At this point, you will be ready to create your Check Point policy.
1. When finished, run `terraform destroy` to remove all of the resources created.

## To-do

I'd like to take the outputs from this script and pass them to Ansible playbooks to automate the Check Point policy configuration too, but that's a project for another day :)