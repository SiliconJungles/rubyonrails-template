output "rds_endpoint" {
  value       = aws_db_instance.rds.address
  description = "RDS Endpoint"
}

output "web_security_group" {
  value       = data.terraform_remote_state.web.outputs.web_security_group_id
  description = "Security Group ID of the web tier"
}