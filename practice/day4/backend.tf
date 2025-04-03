terraform {
  backend "s3" {
    bucket = "demo-s3-terraformstate-harshal"
    key = "Harshal/terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "terraform-lock"
  }
}