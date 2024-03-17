resource "aws_iam_role" "demo" {
  name = var.clusterName

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "demo-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.demo.name
}

resource "aws_eks_cluster" "demo" {
  name     = var.clusterName
  role_arn = aws_iam_role.demo.arn

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

  depends_on = [aws_iam_role_policy_attachment.demo-AmazonEKSClusterPolicy,
  aws_route_table_association.NAT-Gate-rta3,
  aws_route_table_association.NAT-Gate-rta2,
  aws_route_table_association.NAT-Gate-rta1,
  aws_route_table_association.rta1,
  aws_route_table_association.rta2,
  aws_route_table_association.rta3]

}
