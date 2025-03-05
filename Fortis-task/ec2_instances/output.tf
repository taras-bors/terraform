output "private_key_pem" {
  description = "Private key for SSH access"
  value       = tls_private_key.bastion_key.private_key_pem
#  sensitive   = true
}