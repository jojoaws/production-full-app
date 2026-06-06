resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  tags = {
    Name = "${var.project_name}-cluster"
  }
}

resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 30
}

resource "aws_ecs_task_definition" "backend" {
  family       = "${var.project_name}-backend"
  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  cpu    = 256
  memory = 512

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name = "backend"

      image = "${aws_ecr_repository.backend.repository_url}:latest"

      essential = true

      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "AWS_REGION"
          value = var.aws_region
        },
        {
          name  = "USERS_TABLE"
          value = aws_dynamodb_table.users.name
        },
        {
          name  = "UPLOAD_BUCKET"
          value = aws_s3_bucket.uploads.bucket
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.backend.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "backend" {
  name    = "${var.project_name}-backend"
  cluster = aws_ecs_cluster.main.id

  task_definition = aws_ecs_task_definition.backend.arn

  desired_count = 2

  launch_type = "FARGATE"

  network_configuration {
    assign_public_ip = false

    subnets = [
      aws_subnet.private_a.id,
      aws_subnet.private_b.id
    ]

    security_groups = [
      aws_security_group.ecs.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn

    container_name = "backend"
    container_port = 5000
  }

  depends_on = [
    aws_lb_listener.http
  ]
}
