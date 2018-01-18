provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source      = "../../../../modules/vpc"
  environment = "${var.environment}"
}

module "ecs" {
  source = "../../../../modules/ecs"
  name   = "ch_lamb_demo"
}
