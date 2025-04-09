# Create EC2 Key Pair
resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform_key"
  public_key = file("~/.ssh/id_rsa.pub")  # Using the public key path variable
}

# Create a VPC
resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.vpc_cidr  # Using the VPC CIDR block variable
  tags = {
    Name = "terraform_vpc"
  }
}

# Create a subnet
resource "aws_subnet" "terraform_subnet" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = var.subnet_cidr  # Using the subnet CIDR block variable
  availability_zone       = var.availability_zone  # Using the availability zone variable
  map_public_ip_on_launch = true
  tags = {
    Name = "terraform_subnet"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name = "terraform_igw"
  }
}

# Create a route table for the VPC
resource "aws_route_table" "terraform_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_igw.id
  }
}

# Associate route table with subnet
resource "aws_route_table_association" "terraform_route_table_assoc" {
  subnet_id      = aws_subnet.terraform_subnet.id
  route_table_id = aws_route_table.terraform_route_table.id
}

# Create a security group
resource "aws_security_group" "terraform_sg" {
  name        = "terraform_sg"
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



# EC2 instance with user data (shell script)
resource "aws_instance" "terraform_ec2" {
  ami           = var.ami_id  # Using the AMI ID variable
  instance_type = var.instance_type  # Using the instance type variable
  subnet_id     = aws_subnet.terraform_subnet.id
  security_groups = [aws_security_group.terraform_sg.id]
  key_name      = aws_key_pair.terraform_key.key_name

  connection {
    type        = "ssh"
    user        = "ec2-user"  # Default user for Amazon Linux
    private_key = file("~/.ssh/id_rsa") # Path to your private key
    host        = self.public_ip  # EC2 instance public IP
    }
  # Upload the shell script to EC2
  provisioner "file" {
    source      = "shellscript.sh"  # Path to your shellscript.sh
    destination = "/tmp/shellscript.sh"    
  }

  provisioner "remote-exec" {
    inline = [ 
      "sudo yum update -y",
      "cd /tmp",
      "sudo chmod a+wx shellscript.sh",
      "./shellscript.sh"
     ]
  }

  tags = {
    Name = "Terraform EC2"
  }

  # Output EC2 instance public IP
  associate_public_ip_address = true
}

# Output the EC2 public IP and Key Pair download path
output "ec2_public_ip" {
  value = aws_instance.terraform_ec2.public_ip
}

