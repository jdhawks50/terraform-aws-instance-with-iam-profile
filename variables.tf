variable "vpc_id" {
  type = string
}
variable "subnet_id" {
  type = string
}

variable "path_to_iam_policy_document_file" {
  type    = string
  default = "default-workstation-policy.json"
}

variable "iam_policy_document_json" {
  default = {
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Effect" = "Deny"
        "Action" = [
          "*"
        ]
        "Resource" = "*"
      }
    ]
  }
}

variable "aws_ssh_key_name" {
  type = string
}

variable "aws_ami_id" {
  type    = string
  default = ""
}

variable "aws_instance_size" {
  type    = string
  default = "t3a.small"
}

variable "aws_ebs_volume_size" {
  type    = number
  default = 15
}

variable "aws_ebs_volume_type" {
  type    = string
  default = "gp2"
}

variable "aws_ebs_volume_delete_on_instance_termination" {
  type    = bool
  default = true
}

variable "aws_ebs_volume_encryption" {
  type    = bool
  default = false
}

variable "aws_ebs_volume_encryption_key_arn" {
  type    = string
  default = ""
}

variable "aws_instance_associate_public_ip_address" {
  type    = bool
  default = true
}

variable "aws_instance_security_group_ids" {
  type    = list(string)
  default = []
}

variable "security_group_name" {
  type    = string
  default = "aws-admin-workstation-sg"
}

variable "security_group_description" {
  type    = string
  default = "aws-admin-workstation-sg"
}

variable "security_group_ssh_cidr_blocks" {
  type    = list(string)
  default = []
}

variable "iam_role_name" {
  type    = string
  default = "AWSAdminWorkstationIAMRole"
}

variable "iam_role_path" {
  type    = string
  default = "/"
}

variable "iam_role_policy_name" {
  type    = string
  default = "AWSAdminWorkstationPolicy"
}

variable "iam_instance_profile_name" {
  type    = string
  default = "AWSAdminWorkstationProfile"
}