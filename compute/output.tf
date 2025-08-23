output "security_group_eks" {
  value = module.cluster_eks.node_security_group_id
}

output "security_group_web" {
  value = aws_security_group.web_sg.id
}