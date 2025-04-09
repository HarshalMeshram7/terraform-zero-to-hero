# terraform.tfvars

# AWS Region
region = "ap-south-1"  # Change this to your desired AWS region

# VPC CIDR Block
vpc_cidr = "10.0.0.0/16"

# Subnet CIDR Block
subnet_cidr = "10.0.1.0/24"

# Availability Zone
availability_zone = "ap-south-1a"

# AMI ID for EC2 instance
ami_id = "ami-002f6e91abff6eb96"  # Use the appropriate AMI ID

# Instance Type
instance_type = "t2.micro"

# Path to the public key for SSH
public_key_path = "~/.ssh/id_rsa.pub"  # Specify the path to your public key
