variable "ami_id" {
  description = "value of ami-id"
}

variable "instance_type" {
  description = "value of instance-type"
  default = "t2.micro"
}

variable "region" {
  description = "value of region"
}

variable "instance_tags" {
  description = "value of instance tags"
}