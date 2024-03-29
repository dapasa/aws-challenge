# Declaring Terraform Version Required
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.12.1"
    }
  }

  required_version = ">= 0.14.9"
}

# Delcaring Provider
provider "aws" {
  region = var.region
}

# Creating VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = var.availability_zones
  private_subnets = var.priv_ips
  public_subnets  = var.pub_ips

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Creating Security Group
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${var.project_name}-sg"
  description = "Security group for EC2 instances"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Getting Ids from EC2 Instances
data "aws_instances" "ec2_instances_ids" {
  instance_tags = {
    Environment = "dev"
  }
  depends_on = [module.ec2_instance]
}

# Getting EC2 Instances count to use as index
locals {
  instance_length = length(data.aws_instances.ec2_instances_ids.ids)
}

# Creating EC2 Instaces
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  count = 2
  name  = "${var.project_name}-instance-${count.index}"

  ami                         = var.ami
  instance_type               = "t2.micro"
  key_name                    = var.KeyPair
  monitoring                  = true
  vpc_security_group_ids      = [module.security_group.security_group_id]
  subnet_id                   = module.vpc.public_subnets[count.index]
  associate_public_ip_address = "true"

  user_data = file("${path.module}/makeserver.sh")

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Creating a configuring Application Load Balancer
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "alb"

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.security_group.security_group_id]
  target_groups = [
    {
      name             = "${var.project_name}-tg"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = local.instance_length > 0 ? data.aws_instances.ec2_instances_ids.ids[0] : ""
          port      = 80
        },
        {
          target_id = local.instance_length > 1 ? data.aws_instances.ec2_instances_ids.ids[1] : ""
          port      = 80
        }
      ]
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "dev"
  }

  depends_on = [data.aws_instances.ec2_instances_ids]
}

# Getting Application Load Balancer information to show the DNS.
data "aws_lb" "alb" {
  name = var.lb_name
  depends_on = [module.alb]
}