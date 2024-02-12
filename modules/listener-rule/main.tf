resource "aws_lb_listener_rule" "rule" {
  listener_arn = var.listener_arn

  action {
    type             = var.listener_type
    target_group_arn = var.target_group_arn
    }

  condition {
    path_pattern {
      values = [var.path_pattern]
    }
   }

   condition {
    host_header {
      values = [var.host_header]
    }
    }
}