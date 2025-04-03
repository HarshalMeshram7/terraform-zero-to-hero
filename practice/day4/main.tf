resource "aws_instance" "DemoEC2Instance" {
  ami = var.ami_id
  instance_type = var.instance_type
  tags = {
    name = var.instance_tags
  }
}

resource "aws_s3_bucket" "terraformbackend_s3" {
  bucket = var.s3_bucket_name
}

resource "aws_dynamodb_table" "terraform_lock" {
  name = "terraform-lock"
  read_capacity = 20 
  write_capacity = 20
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}