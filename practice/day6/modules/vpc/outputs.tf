output "subnet_id" {
  value = aws_subnet.terraform_subnet.id
}

output "security_groups_id" {
  value = aws_security_group.terraform_sg.id
}