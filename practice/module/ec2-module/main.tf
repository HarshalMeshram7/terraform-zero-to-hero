provider "aws" {
  region = "ap-south-1"
}

module "ec2-instance" {
  source = "../../day3"
  ami_id = "ami-0e35ddab05955cf57"
  region = "ap-south-1"
  instance_type = "t2.micro"
  instance_tags = "demomodule"
}