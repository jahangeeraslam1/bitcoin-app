resource "aws_iam_role" "eksRole" {
  name               = "${local.env}-${local.eks_name}-eks-role"
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

resource "aws_iam_role_policy_attachment" "eksRoleAttach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eksRole.name
}

resource "aws_eks_cluster" "eksCluster" {
  name     = "${local.env}-${local.eks_name}-eks-cluster"
  version  = local.eks_version
  role_arn = aws_iam_role.eksRole.arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true

    subnet_ids = [aws_subnet.private_zone1.id, aws_subnet.private_zone2.id]
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [aws_iam_role_policy_attachment.eksRoleAttach]



}