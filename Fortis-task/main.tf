terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "vpc" {
  source                        = "./vpc"
  cidr_block                    = "10.0.0.0/16"
  public_subnet_cidr            = "10.0.1.0/24"
  front_end_private_subnet_cidr = "10.0.2.0/24"
  back_end_private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones            = ["ca-central-1a", "ca-central-1b"]
}

module "security_groups" {
  source = "./security_groups"
  vpc_id = module.vpc.vpc_id
}

module "databases" {
  source                      = "./databases"
  db_security_group           = module.security_groups.db_security_group
  back_end_private_subnet_ids = module.vpc.back_end_private_subnet_ids
}

module "ec2_instances" {
  source                                = "./ec2_instances"
  ssh_bastion_amazon_ec2_security_group = module.security_groups.ssh_bastion_amazon_ec2_security_group_id
  public_subnet_id                      = module.vpc.public_subnet_id
}