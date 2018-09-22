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

# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "1.40.0"
#
#   name               = "devopsdays-vpc"
#   cidr               = "10.0.1.0/24"
#   azs                = ["us-west-2a", "us-west-2b"]
#   private_subnets    = ["10.0.1.0/26", "10.0.1.64/26"]
#   public_subnets     = ["10.0.1.128/26", "10.0.1.192/26"]
#   enable_nat_gateway = true
# }

resource "aws_key_pair" "nginx" {
  key_name_prefix = "nginx-devopsdays-"
  public_key      = "${file("${path.module}/keys/key.pub")}"
}

output "nginx_ip" {
  value = "${module.nginx.nginx_ip}"
}
