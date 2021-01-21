variable "RAILS_MASTER_KEY" {
  type = string
}

variable "ECR_STDIN" {
  type = string
}

variable "POSTGRES_DB" {
  type = string
}

variable "POSTGRES_USER" {
  type = string
}

variable "POSTGRES_PASSWORD" {
  type = string
}

variable "DOMAIN" {
  type    = string
  default = ""
  //TODO: SET DOMAIN
}

variable "SHA1" {
  type    = string
  default = "latest"
}

variable "APP_NAME" {
  type    = string
  default = "app"
}

variable "ENVIRONMENT" {
  type    = string
  default = "production"
}
