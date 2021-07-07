output "eip_public_ip" {
  value       = aws_eip.web_instance.public_ip
  description = "Public IP of the Elastic IP"
}

output "eip_public_dns" {
  value       = aws_eip.web_instance.public_dns
  description = "Public DNS of the Elastic IP"
}
