terraform {
    variable "DEFAULT_REGION" {
        type        = string
        description = "Default Cloud Region"
    }

    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 3.27"
        }
    }

    required_version = ">= 0.14.9"

    provider "aws" {
        profile = "default"
        region  = var.DEFAULT_REGION
    }

    resource "aws_ecr_repository" "aws_challenge_repo" {
        name = "aws_challenge_repo" # Naming my repository
    }
}