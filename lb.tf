resource "aws_lb" "nginx" {
  name               = "${random_pet.pet.id}-nginx"
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.nginx.id}"]
  subnets            = ["${data.aws_subnet_ids.current.ids}"]
}

resource "aws_lb_target_group" "nginx" {
  name     = "${random_pet.pet.id}-nginx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_target_group_attachment" "nginx" {
  target_group_arn = "${aws_lb_target_group.nginx.arn}"
  target_id        = "${aws_instance.nginx.id}"
}

resource "aws_lb_listener" "nginx_443" {
  load_balancer_arn = "${aws_lb.nginx.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${aws_acm_certificate.cert.arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.nginx.arn}"
  }
}

resource "aws_lb_listener" "nginx_80" {
  load_balancer_arn = "${aws_lb.nginx.arn}"
  port              = "80"
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
