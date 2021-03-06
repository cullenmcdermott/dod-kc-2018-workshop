output "nginx_ip" {
  value = "${aws_instance.nginx.public_ip}"
}

output "dns_endpoint" {
  value = "${aws_route53_record.nginx.fqdn}"
}

output "random_pet" {
  value = "${random_pet.pet.id}"
}
