terraform {
  required_version = "0.12.24"
  backend "s3" {
    bucket  = "tfstate.katsuya-place.com"
    region  = "ap-northeast-1"
    key     = "web01/network/dev.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

module "vpc" {
  source = "../../module/vpc"

  env                             = "dev"
  vpc_cidr_block                  = "10.0.0.0/16"
  subnet_cidr_block_public_a      = "10.0.1.0/24"
  subnet_cidr_block_public_c      = "10.0.2.0/24"
  subnet_cidr_block_private_web_a = "10.0.10.0/24"
  subnet_cidr_block_private_web_c = "10.0.20.0/24"
  subnet_cidr_block_private_db_a  = "10.0.100.0/24"
  subnet_cidr_block_private_db_c  = "10.0.200.0/24"
  az_a                            = "ap-northeast-1a"
  az_c                            = "ap-northeast-1c"
}

# module "natgateway" {
#   source                       = "../../module/natgateway"
# 
#   env                          = "dev"
#   internet_gateway             = module.vpc.internet_gateway
#   subnet_id_public_a           = module.vpc.subnet_id_public_a
#   subnet_id_public_c           = module.vpc.subnet_id_public_c
#   route_table_id_public_a      = module.vpc.route_table_id_public_a
#   route_table_id_public_c      = module.vpc.route_table_id_public_c
#   route_table_id_private_web_a = module.vpc.route_table_id_private_web_a
#   route_table_id_private_web_c = module.vpc.route_table_id_private_web_c
# }

module "security_group" {
  source = "../../module/security_group"

  env    = "dev"
  vpc_id = module.vpc.vpc_id
}
