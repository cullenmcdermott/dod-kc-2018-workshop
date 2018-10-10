provider "aws" {
  region = "us-west-2"
}

resource "random_pet" "pet" {}

resource "aws_security_group" "nginx" {
  name   = "${random_pet.pet.id}-nginx"
  vpc_id = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx" {
  ami                         = "${data.aws_ami.ubuntu_16.id}"
  instance_type               = "${var.instance_type}"
  subnet_id                   = "${data.aws_subnet_ids.current.ids[0]}"
  vpc_security_group_ids      = ["${aws_security_group.nginx.id}"]
  associate_public_ip_address = true
  key_name                    = "${var.key_pair_name}"

  tags {
    Name = "${random_pet.pet.id}-nginx"
  }

  user_data = <<EOF
#!/usr/bin/env bash
apt update
apt install nginx -y
systemctl start nginx
EOF
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "${random_pet.pet.id}.${var.route53_zone_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "nginx" {
  name    = "${random_pet.pet.id}.${var.route53_zone_name}"
  type    = "CNAME"
  zone_id = "${data.aws_route53_zone.this.id}"
  records = ["${aws_lb.nginx.dns_name}"]
  ttl     = 300
}

resource "aws_route53_record" "validation" {
  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.this.id}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = "${aws_acm_certificate.cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.validation.fqdn}"]
}
