resource "aws_ecs_cluster" "ch" {
  name = "${var.name}"
}

resource "aws_ecs_service" "chgo" {
  name            = "${var.name}"
  cluster         = "${aws_ecs_cluster.ch.id}"
  task_definition = "${aws_ecs_task_definition.chservice.arn}"
  desired_count   = 1
}

resource "aws_ecs_task_definition" "chservice" {
  family                = "chservice"
  container_definitions = "${file("task-definitions/chservice.json")}"
}
