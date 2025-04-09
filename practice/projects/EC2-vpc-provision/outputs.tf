output "show_publicIP" {
  value = aws_instance.terraform_ec2.public_ip
}
