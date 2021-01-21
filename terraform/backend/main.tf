provider "aws" {
  region  = "ap-southeast-1"
  version = "~> 2.0"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.APP_NAME}-api-tf-state"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }

  # Enable versioning so that we can see the full revision
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

resource "aws_dynamodb_table" "terraform_lock" {
  name = "${var.APP_NAME}-api-tf-running-locks"

  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
