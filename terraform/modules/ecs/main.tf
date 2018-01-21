resource "aws_ecs_cluster" "ch" {
  name = "${var.name}"
}

resource "aws_ecs_service" "chgo" {
  name            = "${var.name}"
  cluster         = "${aws_ecs_cluster.ch.id}"
  task_definition = "${aws_ecs_task_definition.chservice.family}"
  desired_count   = 1
  launch_type     = "FARGATE"
  # iam_role        = "${aws_iam_role.ecs_service.name}"

  network_configuration = {
    subnets         = ["${var.private_subnet_ids}"]
    security_groups = ["${var.env_sg}"]
  }

  load_balancer {
    container_name = "chfirst"
    container_port = 8080
    target_group_arn = "${aws_lb_target_group.target_group.id}"
  }
}

resource "aws_ecs_task_definition" "chservice" {
  family                   = "chservice4"
  container_definitions    = "${file("${path.module}/task-definitions/chservice.json")}"
  network_mode             = "awsvpc"
  execution_role_arn       = "arn:aws:iam::202368747691:role/ecsTaskExecutionRole"
  cpu                      = "256"
  memory                   = "512"
  requires_compatibilities = ["FARGATE"]
}

resource "aws_lb_target_group" "target_group" {
  name = "chdemo-target"
  port = 8080
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"
  target_type = "ip"
}

resource "aws_lb" "alb" {
  name            = "ch-lb"
  internal        = false
  security_groups = ["${aws_security_group.permit_web.id}", "${var.env_sg}"]
  subnets         = ["${var.public_subnet_ids}"]
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.target_group.arn}"
    type             = "forward"
  }
}

resource "aws_security_group" "permit_web" {
  name        = "permit web 8080"
  description = "permit 8080 to container"
  vpc_id      = "${var.vpc_id}"

  ingress {
    cidr_blocks     = ["0.0.0.0/0"]
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
  }

  ingress {
    cidr_blocks     = ["0.0.0.0/0"]
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }
}


resource "aws_iam_role" "ecs_service" {
  name = "ecs_example_role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
