# Environment
environment = "dev"

# EC2
ec2_web_instance_ami_webserver = "amzn2-ami-hvm-*-x86_64-gp2"
ec2_web_instance_ami_bastion   = "al2023-ami-2023*-x86_64"

ec2_web_instance_type = "t3.micro"
ec2_web_key_name      = "default-key-ec2-username"

# VPC
vpc_cidr = "10.0.0.0/16"

# EKS
eks_kubernetes_version = "1.29"
eks_node_instance_type = "t3.small"
eks_min_size           = 1
eks_max_size           = 5
eks_desired_size       = 1

# RDS
rds_engine         = "mysql"
rds_engine_version = "8.0"
rds_instance_class = "db.t3.micro"