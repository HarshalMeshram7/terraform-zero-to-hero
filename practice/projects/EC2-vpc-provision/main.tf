resource "aws_vpc" "terraform_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraform_vpc"
  }
}

resource "aws_subnet" "terraform_subnet" {
  vpc_id = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "terraform_subnet"
  }
}

resource "aws_internet_gateway" "terraform_IGW" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name = "terraform_IGW"
  }
}

resource "aws_route_table" "terrafor_RT" {
  vpc_id = aws_vpc.terraform_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_IGW.id
  }

  tags = {
    Name = "terraform_RT"
  }
}

resource "aws_route_table_association" "terraformRTA" {
  route_table_id = aws_route_table.terrafor_RT.id
  subnet_id = aws_subnet.terraform_subnet.id
}

resource "aws_security_group" "terraform_SG" {
  name = "terraform_SG"
  description = "allow ssh and http from anywhere"
  vpc_id = aws_vpc.terraform_vpc.id

  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0"]
  }

  tags = {
    Name = "terraform_SG"
  }
}

resource "aws_instance" "terraform_vpc_ec2" {
  ami = "ami-0e35ddab05955cf57"
  instance_type = "t2.micro"
  key_name = "demoec2"
  vpc_security_group_ids = [ aws_security_group.terraform_SG.id ]
  subnet_id = aws_subnet.terraform_subnet.id
  associate_public_ip_address = true

  connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("demoec2.pem")
      host = self.public_ip
  }

  provisioner "file" {
    source = "shellscript.sh"
    destination = "/home/ec2-user/shellscript.sh"
  }

  provisioner "remote-exec" {
    inline = [ 
      "sudo chmod a+rwx shellscript.sh",
      "./shellscript.sh"
     ]
  }
  tags = {
    Name = "terraform-memegenerator"
  }
  
  
}