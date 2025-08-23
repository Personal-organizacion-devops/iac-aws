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

variable "security_group_eks" {
  description = "EKS node security group ID"
  type        = string
}

variable "security_group_web" {
  description = "Web security group ID"
  type        = string
}
