variable "vpc_id" {}

variable "route53_zone_name" {}

variable "key_pair_name" {}

variable "instance_type" {
  default = "t2.micro"
}
