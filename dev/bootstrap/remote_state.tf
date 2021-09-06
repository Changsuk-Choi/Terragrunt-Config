terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.56.0"
    }
  }
}

provider "aws" {
  region  = "us-west-2"
  profile = "bespin-training-terraform"
}

locals {
  project = "bespin"
  env     = "btc" # Don't use delimiters such as . or - or _ in your environment
  stage   = "dev"
  name    = "${local.project}-${local.env}-${local.stage}"
}

resource "aws_s3_bucket" "bucket_terraform_state" {
  bucket = "${local.name}-terraform-state"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "default"
    enabled = true

    prefix = "/"

    noncurrent_version_expiration {
      days = 30
    }
  }

  tags = {
    Name        = "${local.name}-terraform-state"
    Description = "Terraform state files"
    Stage       = local.stage
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_terraform_state" {
  bucket = aws_s3_bucket.bucket_terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "table_terraform_locks" {
  name           = "${local.name}-terraform-locks"
  hash_key       = "LockID"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID" # Must have a primary key named LockID(type: string)
    type = "S"
  }

  tags = {
    Name        = "${local.name}-terraform-locks"
    Description = "Terraform locks table"
    Stage       = local.stage
  }
}
