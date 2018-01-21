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
    elb_name = "ch_lamb_demo1"
    container_name = "chfirst"
    container_port = 8080
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
