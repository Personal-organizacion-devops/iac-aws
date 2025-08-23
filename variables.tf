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

# EKS
variable "eks_kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "eks_node_instance_type" {
  description = "Instance type for EKS worker nodes"
  type        = string
}

variable "eks_min_size" {
  description = "Minimum number of EKS worker nodes"
  type        = number
}

variable "eks_max_size" {
  description = "Maximum number of EKS worker nodes"
  type        = number
}

variable "eks_desired_size" {
  description = "Desired number of EKS worker nodes"
  type        = number
}