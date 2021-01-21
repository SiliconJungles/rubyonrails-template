variable "POSTGRES_DB" {
  type = string
}

variable "POSTGRES_USER" {
  type    = string
  default = "postgres"
}

variable "POSTGRES_PASSWORD" {
  type = string
}

variable "APP_NAME" {
  type    = string
  default = "app"
}
