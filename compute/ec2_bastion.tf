resource "aws_instance" "bastion" {
  ami           = var.ec2_web_instance_ami_id
  instance_type = var.ec2_web_instance_type
  key_name      = var.ec2_web_key_name

  subnet_id                   = var.vpc_public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name

  user_data = <<-EOF
    #!/bin/bash
    yum install -y curl aws-cli
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl && mv kubectl /usr/local/bin/
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    
    aws eks update-kubeconfig --region ${var.region} --name ${module.cluster_eks.cluster_name}

    sudo mkdir -p /home/ec2-user/.kube
    sudo cp /root/.kube/config /home/ec2-user/.kube/config
    sudo chown -R ec2-user:ec2-user /home/ec2-user/.kube

  EOF

  tags = merge(var.tags, { Name = "ec2-${var.app_name}-bastion-${var.environment}" })

  depends_on = [module.cluster_eks]
}

resource "aws_security_group" "bastion_sg" {
  name        = "secgroup-${var.app_name}-bastion-${var.environment}"
  description = "Allow SSH access to bastion"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# EC2 and EKS

resource "aws_security_group_rule" "allow_bastion_to_eks_api" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion_sg.id
  security_group_id        = module.cluster_eks.cluster_security_group_id
  description              = "Allow bastion access to EKS API endpoint"
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "iam-${var.app_name}-bastion-profile-${var.environment}"
  role = aws_iam_role.bastion_kubectl_role.name

  tags = var.tags
}

resource "aws_iam_policy" "eks_kubectl_access" {
  name        = "iam-${var.app_name}-bastion-eks-kubectl-access-${var.environment}"
  description = "Allows the EC2 bastion to execute kubectl on EKS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "sts:AssumeRole"
        ],
        Resource = "*"
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "eks_kubectl_access" {
  role       = aws_iam_role.bastion_kubectl_role.name
  policy_arn = aws_iam_policy.eks_kubectl_access.arn
}