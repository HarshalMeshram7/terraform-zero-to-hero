# variables.tf

# AWS Region
variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "ap-south-1"  # Default region
}

# VPC CIDR Block
variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"  # Default VPC CIDR
}

# Subnet CIDR Block
variable "subnet_cidr" {
  description = "The CIDR block for the subnet."
  type        = string
  default     = "10.0.0.0/24"  # Default subnet CIDR
}

# Availability Zone
variable "availability_zone" {
  description = "The availability zone for the subnet."
  type        = string
  default     = "ap-south-1a"  # Default availability zone
}

# AMI ID for EC2 instance
variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance."
  type        = string
  default     = "ami-002f6e91abff6eb96"  # Example AMI (Change as needed)
}

# Instance Type
variable "instance_type" {
  description = "The type of EC2 instance to create."
  type        = string
  default     = "t2.micro"  # Default EC2 instance type
}

# Path to the public key for SSH
variable "public_key_path" {
  description = "The path to the public key for SSH access."
  type        = string
  default     = "~/.ssh/id_rsa.pub"  # Default path for the public key
}
