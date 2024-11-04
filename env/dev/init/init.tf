terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.0"
    }
  }
}

provider "aws" {
  profile           = "default"
  region            = local.region
}

locals {
  infra_env         = "dev"
  region            = "us-east-1"
}
##############################################
#            backend s3 and dynamodb         #

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "tfstate_lock_dynamodb-avertra"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  deletion_protection_enabled = false
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name                 = "Avertra-${local.infra_env}-dynamodb-tfstate-lock"
    Application          = "AWS DynamoDB"
    Application_Role     = "NOSQL-database"
    Environment          = local.infra_env
    ManagedBy            = "Terraform"   
  }
}



module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.15.1"
  
  bucket = "avertra-iac-state"
  # acl    = "private"
  
  force_destroy             = true
  # block_public_acls         = true
  # block_public_policy       = true
  # ignore_public_acls        = true
  # restrict_public_buckets   = true
  # attach_policy             = true
  # policy                      = "${file("${path.module}/policies/avertra-iac-state.json")}"
  versioning = {
    enabled = true
  }
  
  tags = {
    Name                 = "avertra-iac-state"
    Application          = "AWS S3"
    Application_Role     = "Object Storage Service"
    Environment          = local.infra_env
    ManagedBy            = "Terraform"   
  }
}