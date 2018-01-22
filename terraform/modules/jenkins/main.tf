resource "aws_ecs_cluster" "jenkins" {
  name = "${var.name}"
}

resource "aws_ecs_service" "jenkin-service" {
  name            = "${var.name}"
  cluster         = "${aws_ecs_cluster.jenkins.id}"
  task_definition = "${aws_ecs_task_definition.jenkin-taskdef.family}"
  desired_count   = 1
  launch_type     = "FARGATE"
  # iam_role        = "${aws_iam_role.ecs_service.name}"

  network_configuration = {
    subnets         = ["${var.private_subnet_ids}"]
    security_groups = ["${var.env_sg}"]
  }

  load_balancer {
    container_name = "jenkinsfirst"
    container_port = 8080
    target_group_arn = "${aws_lb_target_group.target_group.id}"
  }
  depends_on = ["aws_lb_target_group.target_group"]
}

resource "aws_ecs_task_definition" "jenkin-taskdef" {
  family                   = "jenkins1"
  container_definitions    = "${file("${path.module}/task-definitions/jenkins-service.json")}"
  network_mode             = "awsvpc"
  execution_role_arn       = "arn:aws:iam::202368747691:role/ecsTaskExecutionRole"
  cpu                      = "512"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]
}

resource "aws_lb_target_group" "target_group" {
  name = "jenkins-target"
  port = 8080
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"
  target_type = "ip"
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = "${var.alb_id}"
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.target_group.arn}"
    type             = "forward"
  }
}
