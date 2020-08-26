resource "aws_lb" "alb" {
  name               = "portal-deploy-test-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancers.id]
  subnets            = [aws_subnet.main.id, aws_subnet.alt.id]

  tags = {
    Environment = "portal_deploy_test"
  }
}

resource "aws_lb_target_group" "echo_server" {
  name     = "echo-server-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.echo_server.arn
  }
}

resource "aws_lb_listener_rule" "routing" {
  listener_arn = aws_lb_listener.listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.echo_server.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

# resource "aws_autoscaling_attachment" "alb_attachment" {
#   autoscaling_group_name = aws_autoscaling_group.ecs-cluster.id
#   alb_target_group_arn   = aws_lb_target_group.echo_server.arn
# }


resource "aws_ecs_task_definition" "echo_server" {
  family                = "echo_server"
  container_definitions = file("task-definitions/echo_server.json")
}

resource "aws_ecs_service" "echo_server" {
  name            = "echo_server"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.echo_server.arn
  iam_role        = aws_iam_role.ecs_service_role.arn
  desired_count   = 2
  depends_on      = [aws_iam_role_policy.ecs_service_role_policy]

  load_balancer {
    target_group_arn = aws_lb_target_group.echo_server.arn
    container_name   = "echo_server"
    container_port   = 8080
  }
}
