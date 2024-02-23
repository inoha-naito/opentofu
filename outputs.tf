output "example_ec2_ip" {
  value = aws_instance.example_ec2.public_dns
}
