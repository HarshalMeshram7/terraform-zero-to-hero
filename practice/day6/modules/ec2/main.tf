# Create EC2 Key Pair
resource "aws_key_pair" "terraform_key" {
  key_name   = var.key_name
  public_key = file("~/.ssh/id_rsa.pub")  # Using the public key path variable
}

# EC2 instance with user data (shell script)
resource "aws_instance" "terraform_ec2" {
  ami           = var.ami_id  # Using the AMI ID variable
  instance_type = var.instance_type  # Using the instance type variable
  subnet_id     = var.subnet_id
  security_groups = [var.security_groups_id]
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
    Name = var.instance_name
  }

  # Output EC2 instance public IP
  associate_public_ip_address = true
}