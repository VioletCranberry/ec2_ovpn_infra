variable "instance_zone" {
  type        = string
  description = "AWS zone"
}

variable "instance_type" {
  type        = string
  description = "EC2 type"
}

variable "_instance_ami" {
  type        = string
  description = "EC2 ami"
}

variable "instance_user" {
  type        = string
  description = "SSH user"
}

variable "instance_port" {
  type        = string
  description = "OpenVPN port"
}

variable "openvpn_proto" {
  type        = string
  description = "OpenVPN protocol"
}
