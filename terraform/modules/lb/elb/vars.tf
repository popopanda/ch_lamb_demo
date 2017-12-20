variable "public_subnet_ids" {
  type = "list"
}

variable "internal" {
  default = true
}

variable "cross_zone_lb" {
  default = true
}

variable "connection_draining" {
  default = true
}

variable "instance_port" {}

variable "lb_port" {}
