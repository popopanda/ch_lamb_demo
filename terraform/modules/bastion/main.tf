# Retreive AMI ID
data "aws_ami" "bastion_ami" {
  most_recent = true

  filter {
    name   = "image-id"
    values = ["${var.ami_id}"]
  }
}

# ASG launch config
resource "aws_launch_configuration" "lc" {
  image_id        = "${data.aws_ami.bastion_ami.id}"
  instance_type   = "${var.instance_type}"
  key_name        = "${var.key_name}"
  security_groups = ["${aws_security_group.permit_ssh.id}"]
  ebs_optimized   = "${var.ebs_optimized}"

  lifecycle {
    create_before_destroy = true
  }
}

# AutoScaling Group
resource "aws_autoscaling_group" "asg" {
  name                      = "${var.environment}-bastion"
  desired_capacity          = "${var.desired_capacity}"
  max_size                  = "${var.max_size}"
  min_size                  = "${var.min_size}"
  launch_configuration      = "${aws_launch_configuration.lc.id}"
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "${var.hc_check_type}"
  vpc_zone_identifier       = ["${var.public_subnet_ids}"]
  min_elb_capacity          = "${var.min_elb_capacity}"
  load_balancers            = []
  termination_policies      = ["${var.asg_term_policy}"]

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "bastion"
    propagate_at_launch = true
  }
}

# Security Group permit_ssh
resource "aws_security_group" "permit_ssh" {
  name        = "allow_ssh"
  description = "allow ssh traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ips}"]
  }

  tags {
    Name = "permit_ssh"
  }
}
