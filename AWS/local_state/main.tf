// AWS provider with latest version
// terraform init - looks for this provider block
// provider details

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

// terraform version should be greater than this version
  required_version = ">= 1.2.0"
}

// Region where the resources will be created
provider "aws" {
  region  = "us-east-1"
}

// Creating a new resource - EC2 instance. Defining parameters
resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform_Demo"
  }
}