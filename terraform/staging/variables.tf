variable "RAILS_MASTER_KEY" {
  type = string
}

variable "ECR_STDIN" {
  type    = string
  default = ""
  // TODO: set ecr url
}

variable "POSTGRES_DB" {
  type    = string
  default = "xxx_production"
  // TODO: set db name
}

variable "POSTGRES_USER" {
  type = string
}

variable "POSTGRES_PASSWORD" {
  type = string
}

variable "DOMAIN" {
  type    = string
  default = "abc.com"
  // TODO: set domain name
}

variable "APP_NAME" {
  type    = string
  default = "app"
}

variable "ENVIRONMENT" {
  type    = string
  default = "staging"
}
