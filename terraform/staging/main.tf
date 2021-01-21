provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket = "${var.APP_NAME}-api-tf-state"
    key    = "staging/web/terraform.tfstate"
    region = "ap-southeast-1"

    dynamodb_table = "${var.APP_NAME}-api-tf-running-locks"
    encrypt        = true
  }
}

resource "aws_security_group" "allow_http" {
  name        = "http_${var.APP_NAME}_${var.ENVIRONMENT}"
  description = "Allow SSH"

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NGINX 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NGINX 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "allow_http"
    Deployer    = "sj_deployer"
    Environment = var.ENVIRONMENT
  }
}

resource "aws_eip" "web_instance" {
  instance = aws_instance.server.id
}

resource "aws_instance" "server" {
  ami                  = "ami-0fd3e3d7875748187"
  instance_type        = "t2.micro"
  security_groups      = [aws_security_group.allow_http.name]
  key_name             = "sj_developer"
  iam_instance_profile = "ecr_reader"
  availability_zone    = "ap-southeast-1a"

  user_data = templatefile("./user_data.sh", {
    domain            = var.DOMAIN,
    db_name           = var.POSTGRES_DB,
    db_user           = var.POSTGRES_USER,
    db_password       = var.POSTGRES_PASSWORD,
    rails_master_key  = var.RAILS_MASTER_KEY,
    ecr_stdin         = var.ECR_STDIN,
    app_name          = var.APP_NAME,
    environment       = var.ENVIRONMENT,
    encrypted_secrets = file("../../config/credentials/${var.ENVIRONMENT}.yml.enc")
  })

  tags = {
    Name        = "${var.APP_NAME}-rails-api-${var.ENVIRONMENT}"
    Deployer    = "sj_deployer"
    Environment = var.ENVIRONMENT
  }
}
