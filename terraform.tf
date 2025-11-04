terraform {

  backend "local" {
    path = "./terraform.tfstate"
  }

  required_version = ">= 1.13"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    # provider_b = {
    #   source  = "value"
    #   version = "value"
    # }

    # provider_c = {
    #   source  = "value"
    #   version = "value"
    # }

  }

}

provider "aws" {
  region = var.aws_region
}
