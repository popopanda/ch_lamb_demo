resource "aws_ecs_cluster" "ch" {
  name = "${var.name}"
}

resource "aws_ecs_service" "chgo" {
  name            = "${var.name}"
  cluster         = "${aws_ecs_cluster.ch.id}"
  task_definition = "${aws_ecs_task_definition.chservice.arn}"
  desired_count   = 1
  launch_type = "FARGATE"

  network_configuration = {
    subnets = ["${var.public_subnet_ids}"]
    security_groups = ["sg-e7095293"]
  }
}

resource "aws_ecs_task_definition" "chservice" {
  family                = "chservice4"
  container_definitions = "${file("${path.module}/task-definitions/chservice.json")}"
  network_mode = "awsvpc"
  execution_role_arn = "arn:aws:iam::202368747691:role/ecsTaskExecutionRole"
  cpu = "256"
  memory = "512"
  requires_compatibilities = ["FARGATE"]
}
