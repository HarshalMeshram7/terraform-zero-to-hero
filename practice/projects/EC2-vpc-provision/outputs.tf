output "show_publicIP" {
  value = aws_instance.terraform_vpc_ec2.public_ip
}