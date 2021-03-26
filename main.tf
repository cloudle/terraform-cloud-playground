# The configuration for the `remote` backend.
terraform {
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "ProsperCI"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "terraform-cloud-playground"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "app" {
  bucket = "terraform-cloud-playground"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}
