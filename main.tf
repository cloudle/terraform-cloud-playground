terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = "~> 0.14"

  backend "remote" {
    organization = "ProsperCI"

    workspaces {
      name = "AppServices"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "app" {
  bucket = "terraform-cloud-playground-renamed"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}
