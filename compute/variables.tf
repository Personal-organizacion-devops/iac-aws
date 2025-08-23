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
  description = "VPC ID where the web server will be deployed"
  type        = string
}
variable "vpc_public_subnets" {
  description = "List of public subnet IDs in the VPC"
  type        = list(string)
}
variable "vpc_private_subnets" {
  description = "List of private subnet IDs in the VPC"
  type        = list(string)
}
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