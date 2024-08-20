locals {
  env         = "dev"       # env needed for objects, policies and amazon EKS clusters
  region      = "eu-west-2" # London region 
  zone1       = "eu-west-2a"
  zone2       = "eu-west-2b" # 2 zones are needed to config an EKS cluster
  eks_name    = "jag-EKS"
  eks_version = 1.29




}