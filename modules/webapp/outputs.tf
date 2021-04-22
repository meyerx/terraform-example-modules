output "ami_id" {
  value       = data.aws_ami.debian_buster.id
  description = "The ID of the AMI that will run on the instances"
}

output "rendered_user_data" {
  value       = data.template_file.user_data.rendered
  description = "The rendered user data for the instance"
}