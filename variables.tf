# Environment
variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prd)"
  type        = string
}

# Web server
variable "ec2_web_instance_ami_id" {
  description = "AMI ID for the web EC2 instance"
  type        = string
}
variable "ec2_web_instance_type" {
  description = "Instance type for the web EC2 instance"
  type        = string
}
variable "ec2_web_key_name" {
  description = "Key name for the web EC2 instance"
  type        = string
}

# VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
