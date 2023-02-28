terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-3"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    # Con esta configuración, junto con el "most_recent", siempre usaremos la última imagen generada.
    values = ["app-symfony-packer-aws-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["545663651640"] # juanvelasco
}

module "webserver" {
  source = "../../modules/webserver/"

  instance_type = var.instance_type
  key_pair_name = var.key_pair_name
  ami_id        = data.aws_ami.ubuntu.id
}
