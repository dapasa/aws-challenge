output "ec2_instance_ids" {
  value = length(data.aws_instances.ec2_instances_ids.ids)
}