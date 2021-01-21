provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket = "${var.APP_NAME}-api-tf-state"
    key    = "production/database/terraform.tfstate"
    region = "ap-southeast-1"

    dynamodb_table = "${var.APP_NAME}-api-tf-running-locks"
    encrypt        = true
  }
}

data "terraform_remote_state" "web" {
  backend = "s3"
  config = {
    bucket = "${var.APP_NAME}-api-tf-state"
    key    = "production/web/terraform.tfstate"
    region = "ap-southeast-1"
  }
}

resource "aws_security_group" "allow_db" {
  name        = "${var.APP_NAME}_web_db_connection"
  description = "Allow 5432 access from the web"

  ingress {
    description     = "From Web Server"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.web.outputs.web_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.APP_NAME} Rails API DB"
    Deployer    = "sj_deployer"
    Environment = "production"
  }
}

resource "aws_db_instance" "rds" {
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "12.2"
  instance_class          = "db.t2.micro"
  identifier              = "${var.APP_NAME}-production"
  backup_retention_period = 7
  name                    = var.POSTGRES_DB
  username                = var.POSTGRES_USER
  password                = var.POSTGRES_PASSWORD
  vpc_security_group_ids  = [aws_security_group.allow_db.id]
}
