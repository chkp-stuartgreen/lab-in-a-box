## Check Point HA Lab-in-a-box

This is a Terraform project to build a demo / POC Check Point HA environment as quickly as possible.  
It will create...

* 2x Check Point R80.40 Gateways in HA with public IPs
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
  
