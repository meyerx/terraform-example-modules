terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}

data "aws_ami" "debian_buster" {
  owners      = ["136693071363"]
  most_recent = true
  name_regex  = "debian-10-amd64-*"
}

resource "random_pet" "vm" {
  keepers = {
    # Generate a new pet name each time we switch to a new AMI id
    ami_id = data.aws_ami.debian_buster.id
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/scripts/user-data.sh")

  vars = {
    server_name = random_pet.vm.id
    server_port = var.server_port
  }
}

