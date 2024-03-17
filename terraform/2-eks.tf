resource "aws_eks_cluster" "eks" {
  name     = "${var.clusterName}-EKS"
  role_arn = aws_iam_role.master.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.sub1.id,
      aws_subnet.sub2.id,
      aws_subnet.sub3.id,
      aws_subnet.sub4.id,
      aws_subnet.sub5.id,
      aws_subnet.sub6.id
    ]
  }

  tags = {
    value = "Prod"
  }


  depends_on = [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy]

}


