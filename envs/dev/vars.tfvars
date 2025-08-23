# Environment
environment = "dev"

# EC2
ec2_web_instance_ami_id = "ami-08a6efd148b1f7504"
ec2_web_instance_type   = "t3.micro"
ec2_web_key_name        = "default-key-ec2-username"

# VPC
vpc_cidr = "10.0.0.0/16"

# EKS
eks_kubernetes_version = "1.29"
eks_node_instance_type = "t3.small"
eks_min_size           = 1
eks_max_size           = 5
eks_desired_size       = 1