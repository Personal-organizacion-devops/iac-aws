terraform {
  backend "s3" {}
}

provider "aws" {
  region = local.region
}