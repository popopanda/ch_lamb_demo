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
  public_subnet_ids = "${module.vpc.public_subnet_ids}"
}
