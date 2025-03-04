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
  public_subnet_cidrs           = ["10.0.1.0/24"]
  front_end_private_subnet_cidr = "10.0.2.0/24"
  back_end_private_subnet_cidr  = "10.0.3.0/24"
  availability_zones            = ["ca-central-1a", "ca-central-1b", "ca-central-1c"]
}

module "security_groups" {
  source = "./security_groups"
  vpc_id        = module.vpc.vpc_id
}
