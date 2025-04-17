module "vpc_module" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  availability_zone = var.availability_zone
  subnet_cidr = var.subnet_cidr
  subnet_name = var.subnet_name
  vpc_name = var.vpc_name
  rt_name = var.rt_name
  igw_name = var.igw_name
  sg_name = var.sg_name
  region = var.region
}

module "ec2_module" {
  source = "./modules/ec2"
  instance_type = var.instance_type
  ami_id = var.ami_id
  instance_name = var.instance_name
  region = var.region
  subnet_id = module.vpc_module.subnet_id
  security_groups_id = module.vpc_module.security_groups_id
  key_name = var.key_name
}