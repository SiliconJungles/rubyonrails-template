provider "aws" {
  region  = "ap-southeast-1"
  version = "~> 2.0"
}

terraform {
  backend "s3" {
    bucket = "${var.APP_NAME}-api-tf-state"
    key    = "setup/terraform.tfstate"
    region = "ap-southeast-1"

    dynamodb_table = "${var.APP_NAME}-api-tf-running-locks"
    encrypt        = true
  }
}

resource "aws_ecr_repository" "repo" {
  name = "${var.APP_NAME}-rails-api"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  repository = aws_ecr_repository.repo.name

  policy = <<EOF
    {
        "rules": [
            {
                "rulePriority": 1,
                "description": "Keep last 30 images",
                "selection": {
                    "tagStatus": "any",
                    "countType": "imageCountMoreThan",
                    "countNumber": 30
                },
                "action": {
                    "type": "expire"
                }
            }
        ]
    }
    EOF
}
