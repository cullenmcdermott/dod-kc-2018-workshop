module "nginx" {
  source            = "../../.."
  vpc_id            = "${data.aws_vpc.current.id}"
  route53_zone_name = "devopsdays.cool"
  key_pair_name     = "${aws_key_pair.nginx.key_name}"
}

data "aws_vpc" "current" {
  tags {
    Name = "devopsdays-vpc"
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_key_pair" "nginx" {
  key_name_prefix = "nginx-devopsdays-"
  public_key      = "${file("${path.module}/keys/key.pub")}"
}

output "nginx_ip" {
  value = "${module.nginx.nginx_ip}"
}

output "dns_endpoint" {
  value = "${module.nginx.dns_endpoint}"
}

output "random_pet" {
  value = "${module.nginx.random_pet}"
}
