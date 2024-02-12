resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = var.subnets_id
  enable_deletion_protection = var.enable_deletion_protection 

  tags = merge(
    {
      "Name" = format("%s", var.alb_name)
    },
    var.tags,
  )

}

# locals {
#   access_logs_info = [
#     {
#     bucket  = var.logs_bucket
#     prefix  = format("%s-alb", var.alb_name)
#     enabled = var.enable_logging
#     }
#   ]
# }

resource "aws_alb_listener" "alb_http_listener" { 
  load_balancer_arn = aws_lb.alb.arn  
  port              = 80  
  protocol          = "HTTP"
  
    default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "alb_https_listener" { 
  count = var.alb_certificate_arn == "" ? 0 : 1
  load_balancer_arn = aws_lb.alb.arn  
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.alb_certificate_arn

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#===================Security Groups====================================
resource "aws_security_group" "main" {
  vpc_id      = var.id_vpc
  
  tags = {
    Name = "alb-sg"
  }
}
resource "aws_security_group_rule" "public_rules"{
  
  for_each          = var.alb_sg_ingress
  type = "ingress"
  from_port         = each.value.from
  to_port           = each.value.to
  protocol          = each.value.protocol
  cidr_blocks       = [each.value.cidr_block]
  description       = each.value.description
  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "public_egress" {
  type              = "egress"
  to_port           = 0
  protocol          = -1
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id
}