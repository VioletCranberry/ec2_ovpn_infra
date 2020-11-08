output "instance_eip" {
  value = module.ec2_instance.instance_eip
}

output "instance_dns" {
  value = module.ec2_instance.instance_dns
}
