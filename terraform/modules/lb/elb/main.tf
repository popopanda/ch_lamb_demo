resource "aws_elb" "elb" {
  count           = 1
  name            = "${var.environment}-${count.index + 1}"
  security_groups = []

  subnets                   = ["${var.public_subnet_ids}"]
  internal                  = "${var.internal}"
  cross_zone_load_balancing = "${var.cross_zone_lb}"
  connection_draining       = "${var.connection_draining}"
  idle_timeout              = 360

  listener {
    instance_port     = "${var.instance_port}"
    instance_protocol = "tcp"
    lb_port           = "${var.lb_port}"
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 1
    unhealthy_threshold = 1
    timeout             = 3
    target              = "tcp:22"
    interval            = 30
  }
}
