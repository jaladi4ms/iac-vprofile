resource "aws_eks_node_group" "private-node-grp" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "Worker-Node-Group1"
  node_role_arn   = aws_iam_role.worker.arn

  subnet_ids = [
    aws_subnet.sub4.id,
    aws_subnet.sub5.id,
    aws_subnet.sub6.id
  ]

  capacity_type  = "SPOT"
  ami_type       = "AL2_x86_64"
  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    Name = "Node-grp1"
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

