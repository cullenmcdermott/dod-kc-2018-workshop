module "nginx" {
  source            = "../../.."
  vpc_id            = "${data.aws_vpc.current.id}"
  subnet_ids        = ["${data.aws_subnet_ids.dod.ids[0]}", "${data.aws_subnet_ids.dod.ids[2]}"]
  route53_zone_name = "aws.cullenmcdermott.com"
  key_pair_name     = "${aws_key_pair.nginx.key_name}"
}

data "aws_vpc" "current" {
  tags {
    Name = "devopsdays-vpc"
  }
}

data "aws_subnet_ids" "dod" {
  vpc_id = "${data.aws_vpc.current.id}"
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
