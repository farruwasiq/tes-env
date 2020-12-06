resource "aws_lb" "tes_lb" {
  internal           = true
  load_balancer_type = "network"
  subnets            = data.aws_subnet_ids.public.ids

  enable_deletion_protection = true

  tags = merge(local.required_tags, map(
    "Name", join("-", [local.prefix, "tes_lb"]),
    "lll:deployment:role", "tes_lb",                     # The role of the server. Normally same as Ansible role/group. Will show up in alerts.
    "lll:monitoring:node-exporter", "enabled",           # This allow Prometheus to discover your instance automatically
    "lll:monitoring:owner", join("-", [var.app, "eng"]), # Change this to match the alert receiver in Alertmanager
  ))
}

resource "aws_lb_listener" "tes_lb_http" {
  load_balancer_arn = aws_lb.tes_lb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.tes_lb_target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "tes_lb_https" {
  load_balancer_arn = aws_lb.tes_lb.arn
  port              = 443
  protocol          = "TCP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = data.aws_acm_certificate.wildcard_aws_lllint_com.arn

  default_action {
    target_group_arn = aws_lb_target_group.tes_lb_target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "tes_lb_custom" {
  load_balancer_arn = aws_lb.tes_lb.arn
  port              = 8080
  protocol          = "TCP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = data.aws_acm_certificate.wildcard_aws_lllint_com.arn

  default_action {
    target_group_arn = aws_lb_target_group.tes_lb_target_group.arn
    type             = "forward"
  }
}

resource "aws_lb_target_group" "tes_lb_target_group" {
  name     = "tf-lb-tg"
  port     = 8080
  protocol = "TCP"
  vpc_id   = data.aws_vpc.main.id

  tags = merge(local.required_tags, map("Name", join("-", [local.prefix, "tes_lb_target_group"])))
}
