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

# CREATE THE S3 BUCKET

data "aws_caller_identity" "current" {}

locals {
   account_id    = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "terraform_state" {
  # With account id, this S3 bucket names can be *globally* unique.
  bucket = "${local.account_id}-terraform-states"

  # Enable versioning so we can see the full revision history of our state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# CREATE THE DYNAMODB TABLE

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    encrypt = true
    bucket  = "<account-id>-terraform-states"
    key     = "development/service-name.tfstate"
    region = "us-east-1"
    dynamodb_table = "terraform-lock"
  }
}

# example of 'partial configuration':
# https://www.terraform.io/docs/backends/config.html#partial-configuration
#
# cat config/backend-dev.conf


// Creating a new resource - EC2 instance. Defining parameters
resource "aws_instance" "app_server" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform_Demo"
  }
}

