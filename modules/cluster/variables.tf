# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "ssh_key_name" {
  description = "Name of the aws key-pair assigned to this user"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs of the AWS subnet declared in the VPC"
  type        = list(any)
  validation {
    condition     = length(var.subnet_ids) <= 2
    error_message = "There must be at least 2 subnets having different availability zones."
  }
}

variable "vpc_security_group_ids" {
  description = "IDs of the security groups associated with the VPC"
  type        = list(any)
}

variable "server_port" {
  description = "The name to use for all the cluster resources"
  type        = number
}

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "ami_id" {
  description = "The ID of the AMI that will run on the instances"
  type        = string
}

variable "rendered_user_data" {
  description = "The rendered user data for the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
}

variable "min_instance" {
  description = "Minimum number of instances in the cluster."
  type        = number
  validation {
    condition     = var.min_instance >= 1
    error_message = "There must be at least 1 instance."
  }
}

variable "max_instance" {
  description = "Maximum number of instances in the cluster."
  type        = number
  validation {
    condition     = var.max_instance <= 10
    error_message = "There must be at most 10 instances."
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# You can provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------


variable "instance_warmup" {
  description = "The number of seconds until a newly launched instance is configured and ready to use."
  type        = number
  default     = 300
}
