resource "aws_lb" "frontend_alb" {
    name               = "frontend-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.frontend-alb.id]
    subnets = [ aws_subnet.public-1.id, aws_subnet.public-2.id ]
    enable_deletion_protection = false

    tags = {
        Name = "frontend-alb"
    }
}

resource "aws_lb_target_group" "frontend_tg" {
    name        = "frontend-tg"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = aws_vpc.tier_appliction.id
    target_type = "instance"

    health_check {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 3
        unhealthy_threshold = 3
    }

    tags = {
        Name = "frontend-tg"
    }
}

resource "aws_lb_listener" "frontend_listener" {
    load_balancer_arn = aws_lb.frontend_alb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.frontend_tg.arn
    }
}

resource "aws_lb" "backend_alb" {
    name               = "backend-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.backend-alb.id]
    subnets            = [ aws_subnet.public-2.id, aws_subnet.public-1.id ]

    enable_deletion_protection = false

    tags = {
        Name = "backend-alb"
    }
}
resource "aws_lb_target_group" "backend_tg" {
    name        = "backend-tg"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = aws_vpc.tier_appliction.id
    target_type = "instance"

    health_check {
        path                = "/"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 3
        unhealthy_threshold = 3
    }

    tags = {
        Name = "backend-tg"
    }
}
resource "aws_lb_listener" "backend_listener" {
    load_balancer_arn = aws_lb.backend_alb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.backend_tg.arn
    }
}