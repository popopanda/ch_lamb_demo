variable "environment" {}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "enable_dns_support" {
  default = true
}

variable "enable_dns_hostnames" {
  default = true
}

variable "zone" {
  default = ["a", "b", "c", "e"]
}

variable "public_cidr_block" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}

variable "private_cidr_block" {
  default = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24", "10.0.14.0/24"]
}
