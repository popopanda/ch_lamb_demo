provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source      = "../../../../modules/vpc"
  environment = "${var.environment}"
}

# module "bastion" {
#   source            = "../../../../modules/bastion"
#   ami_id            = ""
#   key_name          = "mykey.pem"
#   environment       = "${var.environment}"
#   public_subnet_ids = "${module.vpc.public_subnet_ids}"
#   vpc_id            = "${module.vpc.vpc_id}"
# }
