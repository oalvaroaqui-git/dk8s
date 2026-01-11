output "instance_ids" {
  value       = aws_instance.k8s_nodes[*].id
  description = "EC2 instance IDs"
}

output "public_ips" {
  value       = aws_instance.k8s_nodes[*].public_ip
  description = "Public IPs for SSH"
}
