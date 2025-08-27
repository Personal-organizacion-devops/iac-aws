# App
variable "environment" {
  type = string
}
variable "app_name" {
  type = string
}
variable "region" {
  type = string
}
variable "tags" {
  type = map(string)
}

# Parameters
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "vpc_private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
}
variable "vpc_single_availability_zone" {
  description = "The single availability zone for the VPC"
  type        = string
}

variable "security_group_eks" {
  description = "EKS node security group ID"
  type        = string
}

variable "security_group_web" {
  description = "Web security group ID"
  type        = string
}

variable "rds_engine" {
  description = "The database engine to use"
  type        = string
}

variable "rds_engine_version" {
  description = "The version of the database engine"
  type        = string
}

variable "rds_instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
}