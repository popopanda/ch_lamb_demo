variable "name" {}

variable "private_subnet_ids" {
  type = "list"
}

variable "public_subnet_ids" {
  type = "list"
}

variable "env_sg" {}

variable "vpc_id" {}
