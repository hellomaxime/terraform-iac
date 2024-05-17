output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web_app.id
}

output "instance_public_ip" {
  description = "EC2 instance public ip"
  value       = aws_instance.web_app.public_ip
}

output "instance_name" {
  value = aws_instance.web_app.tags.Name
}