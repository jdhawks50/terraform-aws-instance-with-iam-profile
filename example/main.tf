terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "instance_with_iam_profile" {
    source = "github.com/jdhawks50/terraform-aws-instance-with-iam-profile"


    vpc_id           = "vpc-fakevpcid12345678"
    subnet_id        = "subnet-fakesubnetid12"
    
    aws_ssh_key_name = "example-ssh-key"

    # This policy DENIES all AWS API actions.
    iam_policy_document_json = {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Deny",
          "Action" : [
            "*"
          ],
          "Resource" : "*"
        }
      ]
    }
}