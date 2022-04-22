variable "vpc_id" {
  description = "The VPC ID that the instance will be created in."
  type = string
}
variable "subnet_id" {
  type = string
  description = "The Subnet ID that the instance will be created in. The Subnet must be a member of the specified VPC ID."
}

variable "path_to_iam_policy_document_file" {
  type    = string
  default = "default-workstation-policy.json"
  description = "The absolute file path to the IAM JSON policy document."
}

variable "iam_policy_document" {
  type        = string
  description = "An IAM Policy Document written as HCL. This will be converted to json using Terraform's bultin `jsonencode()` function."
  default = ""
  ## default = <<-POLICY
  ## {
  ##   "Version": "2012-10-17",
  ##   "Statement": [
  ##     {
  ##       "Effect": "Deny",
  ##       "Action": [
  ##         "*"
  ##       ],
  ##       "Resource": "*"
  ##     }
  ##   ]
  ## }
  ## POLICY
}

variable "aws_ssh_key_name" {
  description = "The name of the AWS SSH key associated with the instance."
  type = string
  default = ""
}

variable "aws_ami_id" {
  description = "An AWS AMI ID to use for the instance. By default, the latest Ubuntu 20.04 LTS AMI is used."
  type    = string
  default = ""
}

variable "aws_instance_size" {
  description = "The size of the AWS instance. By default, the instance size is t3a.small."
  type    = string
  default = "t3a.small"
}

variable "aws_ebs_volume_size" {
  description = "The size, in GiB, of the EBS volume."
  type    = number
  default = 15
}

variable "aws_ebs_volume_type" {
  description = "The type of AWS EBS volume to use."
  type    = string
  default = "gp2"
}

variable "aws_ebs_volume_delete_on_instance_termination" {
  description = "Whether to delete the EBS volume on instance termination. Defaults to true."
  type    = bool
  default = true
}

variable "aws_ebs_volume_encryption" {
  description = "Whether to encrypt the EBS volume."
  type    = bool
  default = false
}

variable "aws_ebs_volume_encryption_key_arn" {
  description = "The ARN of the AWS KMS Key used to encrypt the EBS volume. Required if encryption is enabled."
  type    = string
  default = ""
}

variable "aws_instance_associate_public_ip_address" {
  description = "Whether to provide the instance with a public IP address."
  type    = bool
  default = true
}

variable "aws_instance_security_group_ids" {
  description = "A list of AWS VPC security group IDs to apply to the instance. Maximum of 5 allowed per AWS limitations. Not required."
  type    = list(string)
  default = []
}

variable "security_group_name" {
  description = "The name of the terraform-generated AWS security group."
  type    = string
  default = "aws-admin-workstation-sg"
}

variable "instance_name" {
  description = "Name tag on the instance."
  type = string
  default = "aws-admin-workstation"
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

variable "instance_user_data" {
  type = string
  default = ""
}