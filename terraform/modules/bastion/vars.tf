variable "ami_id" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {}

variable "ebs_optimized" {
  default = true
}

variable "environment" {}

variable "desired_capacity" {
  default = 1
}

variable "max_size" {
  default = 1
}

variable "min_size" {
  default = 1
}

variable "health_check_grace_period" {
  default = "300"
}

variable "hc_check_type" {
  default = "elb"
}

variable "public_subnet_ids" {
  type = "list"
}

variable "min_elb_capacity" {
  default = 1
}

variable "asg_term_policy" {
  default = "OldestInstance"
}

variable "vpc_id" {}

# Placeholder ip address
variable "ips" {
  default = "127.0.0.1/32"
}
