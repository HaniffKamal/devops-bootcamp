output "server_id" {
  description = "EC2 instance ID"
  value       = module.my_server.id
}

output "rackula_url" {
  description = "Public URL of the Rackula web UI"
  value       = "http://${module.my_server.public_ip}:8080"
}

output "ssm_command" {
  description = "AWS Systems Manager Session Manager command"
  value       = "aws ssm start-session --target ${module.my_server.id}"
}
