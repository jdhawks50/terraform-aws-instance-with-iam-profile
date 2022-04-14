terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70.0"
    }
  }
}

data "aws_ami" "ubuntu_ami" {
  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  most_recent = true
}

data "http" "my_ip_address" {
  url = "https://api.ipify.org?format=json"
}

resource "aws_security_group" "security_group" {
  count       = length(var.aws_instance_security_group_ids) > 0 ? 0 : 1
  name        = var.security_group_name
  description = var.security_group_description
  vpc_id      = var.vpc_id

  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = length(var.security_group_ssh_cidr_blocks) > 0 ? var.security_group_ssh_cidr_blocks : [
      format("%s/32", jsondecode(data.http.my_ip_address.body).ip)
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "instance" {
  ami           = var.aws_ami_id == "" ? data.aws_ami.ubuntu_ami.id : var.aws_ami_id
  instance_type = var.aws_instance_size

  key_name  = var.aws_ssh_key_name
  subnet_id = var.subnet_id

  iam_instance_profile = aws_iam_instance_profile.workstation_instance_profile.name

  associate_public_ip_address = var.aws_instance_associate_public_ip_address

  vpc_security_group_ids = length(var.aws_instance_security_group_ids) > 0 ? var.aws_instance_security_group_ids : [
    aws_security_group.security_group[0].id
  ]

  root_block_device {
    delete_on_termination = var.aws_ebs_volume_delete_on_instance_termination
    volume_size           = var.aws_ebs_volume_size
    volume_type           = var.aws_ebs_volume_type
    encrypted             = var.aws_ebs_volume_encryption ? true : false
    kms_key_id            = var.aws_ebs_volume_encryption ? var.aws_ebs_volume_encryption_key_arn : null
  }

  user_data = var.instance_user_data
}

resource "aws_iam_instance_profile" "workstation_instance_profile" {
  name = var.iam_instance_profile_name
  role = aws_iam_role.workstation_role.name
}

resource "aws_iam_role" "workstation_role" {
  name = var.iam_role_name
  path = var.iam_role_path

  assume_role_policy = <<-EOF
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Action": "sts:AssumeRole",
              "Principal": {
                 "Service": [
                     "ec2.amazonaws.com"
                ]
              },
              "Effect": "Allow",
              "Sid": ""
          }
      ]
  }
  EOF
}

resource "aws_iam_role_policy" "workstation_instance_policy" {
  name   = var.iam_role_policy_name
  role   = aws_iam_role.workstation_role.id
  policy = var.iam_policy_document_json
}

output "instance_public_ip" {
  value = var.aws_instance_associate_public_ip_address ? aws_instance.instance.public_ip : null
}