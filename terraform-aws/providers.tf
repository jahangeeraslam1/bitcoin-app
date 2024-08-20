provider "aws" {
  region = local.region
}




terraform {
  required_version = ">= 1.0" #specifies min terraform version 

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49" #allows terraform to use any aws version >= 5.49.0 and < 6.0.0. 
    }
    
    helm = {
      source = "hashicorp/helm"
      version = "2.14.1"
    }

    # kubernetes = {
    #   source  = "hashicorp/kubernetes"
    #   version = "~> 2.20"
    # }
  }
}

