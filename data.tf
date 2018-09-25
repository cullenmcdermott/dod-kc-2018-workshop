data "aws_route53_zone" "this" {
  name = "${var.route53_zone_name}"
}

data "aws_ami" "ubuntu_16" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-*"]
  }
}

data "aws_subnet_ids" "current" {
  vpc_id = "${var.vpc_id}"
}
