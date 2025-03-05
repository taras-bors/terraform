output "web_app_server_id" {
  description = "Web App Server Id"
  value = aws_instance.web_app_server.id
}

output "private_key_pem" {
  description = "Private key for SSH access"
  value       = tls_private_key.bastion_key.private_key_pem
  sensitive   = true
}

