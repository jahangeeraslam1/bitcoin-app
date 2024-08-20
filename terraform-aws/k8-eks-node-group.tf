resource "aws_iam_role" "workerNodeRole" {
  name               = "${local.env}-${local.eks_name}-worker-node-role"
  assume_role_policy = <<POLICY
            {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
            }
        ]
        }
        POLICY  
}


resource "aws_iam_role_policy_attachment" "workerNodeAttachPolicyEKS" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

  role = aws_iam_role.workerNodeRole.name
}

resource "aws_iam_role_policy_attachment" "workerNodeAttachPolicyCNI" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.workerNodeRole.name
}

resource "aws_iam_role_policy_attachment" "workerNodeAttachPolicyCRReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.workerNodeRole.name
}



resource "aws_eks_node_group" "general" {
  cluster_name = aws_eks_cluster.eksCluster.name
  version      = local.eks_version

  node_group_name = "general"
  node_role_arn   = aws_iam_role.workerNodeRole.arn
  subnet_ids      = [aws_subnet.private_zone1.id, aws_subnet.private_zone2.id]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.large"]

  scaling_config {
    desired_size = 1
    max_size     = 10
    min_size     = 0
  }

  update_config { #used for cluster upgrades
    max_unavailable = 1
  }

  labels = { #can use them in port infinity and node selector
    #there are some  biult in labvels dervided from node gorup names 
    role = "general"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.workerNodeAttachPolicyEKS,
    aws_iam_role_policy_attachment.workerNodeAttachPolicyCNI,
    aws_iam_role_policy_attachment.workerNodeAttachPolicyCRReadOnly
  ]

  # Optional: Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }


}