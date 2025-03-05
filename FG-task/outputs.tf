output "ssh_key" {
  description = "Private key for SSH access"
  value       = module.ec2_instances.private_key_pem
  sensitive   = true
}
