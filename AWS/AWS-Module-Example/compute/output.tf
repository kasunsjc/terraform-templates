output "instance_public_ip" {
  value = aws_instance.ec2_instance.public_ip
}

output "instance_public_dns" {
  value = aws_instance.ec2_instance.public_dns
}

output "instance_name" {
  value = aws_instance.ec2_instance.tags.Name
}