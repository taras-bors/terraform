terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "vpc" {
  source              = "./vpc"
  cidr_block          = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.2.0/24", "10.0.3.0/24"]
  availability_zones  = ["ca-central-1a", "ca-central-1b", "ca-central-1c"]
}