###VPC details
# VPC ID
output "vpc_id" {
  value = aws_vpc.myvpc.id
}

# ID of subnet in AZ1 
output "public_subnet1_id" {
  value = aws_subnet.sub1.id
}

# ID of subnet in AZ2
output "public_subnet2_id" {
  value = aws_subnet.sub2.id
}

output "public_subnet3_id" {
  value = aws_subnet.sub3.id
}
# Internet Gateway ID
output "internet_gateway" {
  value = aws_internet_gateway.igw.id
}

###IAM roles for EKS

# IAM Wokrer Node Instance Profile 
output "instance_profile" {
  value = aws_iam_instance_profile.worker.name
}

# IAM Role Master's ARN
output "master_arn" {
  value = aws_iam_role.master.arn
}

# IAM Role Worker's ARN
output "worker_arn" {
  value = aws_iam_role.worker.arn
}

# EKS Cluster ID
output "aws_eks_cluster_name" {
  value = aws_eks_cluster.eks.id
}