data "aws_iam_policy_document" "aws_lbc"{
    statement{
        effect = "Allow"
    
    principals {
        type = "Service"
        identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
        "sts:AssumeRole",
        "sts:TagSession"
    ]
}

}

resource "aws_iam_role" "aws_lbc_role" {
    name = "${aws_eks_cluster.eksCluster.name}-aws-lbc"
    assume_role_policy = data.aws_iam_policy_document.aws_lbc.json
}
  
  
resource "aws_iam_policy" "aws_lbc_policy" {
  policy = file("./AWSLoadBalancerController.json")
  name   = "AWSLoadBalancerController"
}

resource "aws_iam_role_policy_attachment" "aws_lbc_attach" {
  policy_arn = aws_iam_policy.aws_lbc_policy.arn
  role       = aws_iam_role.aws_lbc_role.name

 depends_on = [aws_eks_cluster.eksCluster, aws_eks_node_group.general]

}


resource "aws_eks_pod_identity_association" "aws_lbc_link" {
    cluster_name = aws_eks_cluster.eksCluster.name
    namespace = "kube-system"
    service_account = "aws-load-balancer-controller"
    role_arn = aws_iam_role.aws_lbc_role.arn
  
}


resource "helm_release" "aws_lbc_helm" {
    name = "aws-load-balancer-controller"

    repository = "https://aws.github.io/eks-charts"
    chart = "aws-load-balancer-controller"
    namespace = "kube-system"
    version = "1.8.1"

  set {
    name  = "clusterName"
    value = aws_eks_cluster.eksCluster.name
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

    set {
    name  = "vpcId"
    value = aws_vpc.mainVPC.id
  }

  depends_on = [helm_release.cluster_autoscaler]
  
}