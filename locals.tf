locals {
  name   = "my-webapp"
  region = "us-east-1"

  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    AppName     = local.name
    Environment = var.environment
  }
}