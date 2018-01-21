provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source      = "../../../../modules/vpc"
  environment = "${var.environment}"
}

# Bug in Terraform that does not permit "assign public ip"

module "ecs" {
  source            = "../../../../modules/ecs"
  name              = "ch_lamb_demo"
  private_subnet_ids = "${module.vpc.private_subnet_ids}"
  env_sg = "${module.vpc.env_sg}"
}
