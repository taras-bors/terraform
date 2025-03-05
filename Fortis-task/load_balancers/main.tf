resource "aws_lb" "web_app_lb" {
  name               = "web-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.elastic_load_balancer_security_group]
  subnets            = [var.public_subnet_id]

  tags = {
    Name = "web_app-alb"
  }
}

resource "aws_lb_target_group" "web_app_tg" {
  name        = "web-app-target-group"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "web_app_target_group"
  }
}

resource "aws_lb_target_group_attachment" "web_app_tg_attachment" {
  target_group_arn = aws_lb_target_group.web_app_tg.arn
  target_id        = var.web_app_server_id
  port             = 8080
}

#The AWS Certificate Manager section is for example only, as the real domain needed.
#resource "aws_acm_certificate" "example" {
#  domain_name       = "example.com"
#  validation_method = "DNS"
#}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.web_app_lb.arn
  port              = 443
  protocol          = "HTTPS"
# Disabled as a certificate needed
#  ssl_policy        = "ELBSecurityPolicy-2016-08" # Choose an appropriate SSL policy
#  certificate_arn   = aws_acm_certificate.example.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_app_tg.arn
  }
}



