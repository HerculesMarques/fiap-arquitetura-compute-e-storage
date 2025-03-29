provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

resource "aws_ecs_cluster" "lab_cluster" {
  name = "ecs-fargate-lab-cluster"
}

resource "aws_ecr_repository" "app" {
  name = "ecs-fargate-lab"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "ecs-fargate-lab-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"

  container_definitions = jsonencode([
    {
      name      = "app",
      image     = "${aws_ecr_repository.app.repository_url}:latest",
      essential = true,
      portMappings = [
        {
          containerPort = 3000,
          hostPort      = 3000,
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "app_service" {
  name            = "ecs-fargate-app-service"
  cluster         = aws_ecs_cluster.lab_cluster.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [random_shuffle.random_subnet.result[0]]
    security_groups  = [aws_security_group.sec-fargate.id]
    assign_public_ip = true
  }
}
