resource "aws_key_pair" "infra" {
  key_name   = "infra-key"
  public_key = file("${path.module}/files/${var.instance_zone}/ssh_key.pub")
}

resource "aws_instance" "openvpn-instance" {
  ami               = var._instance_ami
  instance_type     = var.instance_type
  availability_zone = var.instance_zone
  key_name          = aws_key_pair.infra.id
  security_groups   = [
    "${aws_security_group.openvpn-instance.name}"
  ]
  tags = {
    Name = "open_vpn"
    Role = "open_vpn"
  }
  user_data = <<EOF
    #cloud-config
    system_info:
      default_user:
        name: "${var.instance_user}"
  EOF
}

resource "aws_security_group" "openvpn-instance" {
  name        = "allow_traffic_flow"
  description = "allow_traffic_flow"

  ingress {
    from_port   = "${var.instance_port}"
    to_port     = "${var.instance_port}"
    protocol    = "${var.openvpn_proto}"
    cidr_blocks = [
      "${data.http.source_ip.body}/32"
    ]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "${data.http.source_ip.body}/32"
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Role = "open_vpn"
  }
}

resource "aws_eip" "instance_ip" {
  instance = aws_instance.openvpn-instance.id
  vpc      = true

  depends_on = [
    aws_instance.openvpn-instance
  ]
}
