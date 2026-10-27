output "web_public_ip" {
  description = "Public IPv4 address of the web server"
  value       = aws_instance.web.public_ip
}

output "web_private_ip" {
  description = "Private IPv4 address of the web server"
  value       = aws_instance.web.private_ip
}

output "web_instance_id" {
  description = "EC2 instance ID of the web server"
  value       = aws_instance.web.id
}

output "database_private_ip" {
  description = "Private IPv4 address of the database server"
  value       = aws_instance.database.private_ip
}

output "database_instance_id" {
  description = "EC2 instance ID of the private database server"
  value       = aws_instance.database.id
}

output "vpc_id" {
  description = "VPC created for the assignment"
  value       = aws_vpc.main.id
}
