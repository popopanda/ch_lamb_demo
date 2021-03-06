terraform {
  backend "s3" {
    bucket = "ch-tfstate"
    key    = "demo/key"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source      = "../../../../modules/vpc"
  environment = "${var.environment}"
}

# Bug in Terraform that does not permit "assign public ip"

module "helloch" {
  source             = "../../../../modules/helloch"
  name               = "ch_lamb_demo"
  private_subnet_ids = "${module.vpc.private_subnet_ids}"
  public_subnet_ids  = "${module.vpc.public_subnet_ids}"
  env_sg             = "${module.vpc.env_sg}"
  vpc_id             = "${module.vpc.vpc_id}"
}
