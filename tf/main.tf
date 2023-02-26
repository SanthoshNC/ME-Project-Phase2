terraform {
  backend "s3" {
    bucket = "santhoshnc-terraform-tfstate-me"
    key    = "demo-tf-project.tfstate"
    region = "us-east-1"
  }
}

locals {
  common_tags = {
    Project     = "ME-Project-Phase2"
    ManagedBy   = "Terraform"
    Environment = var.environment_name
  }
}

resource "aws_s3_bucket" "me-project-s3-bucket" {
  #ts:skip=AC_AWS_0497 We don't need logging for this S3 bucket
  bucket = var.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  tags = local.common_tags
}

resource "aws_s3_bucket_public_access_block" "me-project-s3-bucket-access" {
  bucket                  = aws_s3_bucket.me-project-s3-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
