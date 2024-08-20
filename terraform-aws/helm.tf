data "aws_eks_cluster" "eksCluster"{
    name = aws_eks_cluster.eksCluster.name
}

data "aws_eks_cluster_auth" "eksCluster"{
    name = aws_eks_cluster.eksCluster.name
}


# Helm provider to deploy the AWS Load Balancer Controller
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eksCluster.endpoint
    token                  = data.aws_eks_cluster_auth.eksCluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eksCluster.certificate_authority[0].data)
  }
}






