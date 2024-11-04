output "NodeInstanceRole" {
  value = aws_iam_role.node_instance_role.arn
}

output "NodeSecurityGroup" {
  value = aws_security_group.node_security_group.id
}

output "NodeAutoScalingGroup" {
  value = aws_cloudformation_stack.autoscaling_group.outputs["NodeAutoScalingGroup"]
}

output "endpoint" {
  value = aws_eks_cluster.demo_eks.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.demo_eks.id
}

output "certificate_authority" {
  value = aws_eks_cluster.demo_eks.certificate_authority
}