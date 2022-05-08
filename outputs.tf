output "ec2_instance_ids" {
  value = length(data.aws_instances.ec2_instances_ids.ids)
}

output "albdns" {
  value = data.aws_lb.alb.dns_name
}