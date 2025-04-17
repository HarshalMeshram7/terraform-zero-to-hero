# Create a VPC
resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.vpc_cidr  # Using the VPC CIDR block variable
  tags = {
    Name = var.vpc_name
  }
}

# Create a subnet
resource "aws_subnet" "terraform_subnet" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = var.subnet_cidr  # Using the subnet CIDR block variable
  availability_zone       = var.availability_zone  # Using the availability zone variable
  map_public_ip_on_launch = true
  tags = {
    Name = var.subnet_name
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name = var.igw_name
  }
}

# Create a route table for the VPC
resource "aws_route_table" "terraform_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_igw.id
  }

  tags = {
    Name = var.rt_name
  }
}

# Associate route table with subnet
resource "aws_route_table_association" "terraform_route_table_assoc" {
  subnet_id      = aws_subnet.terraform_subnet.id
  route_table_id = aws_route_table.terraform_route_table.id
}

# Create a security group
resource "aws_security_group" "terraform_sg" {
  name        = var.sg_name
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
