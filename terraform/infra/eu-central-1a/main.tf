module "ec2_instance" {
  source           = "../../modules/openvpn-instance/"

  instance_user = var.instance_user
  _instance_ami = var._instance_ami  
  instance_type = var.instance_type
  instance_zone = var.instance_zone

  instance_port = var.instance_port # OpenVPN port 
  openvpn_proto = var.openvpn_proto # OpenVPN proto
  
}
