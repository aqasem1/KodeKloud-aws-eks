
terraform {
  required_providers {
    aws = {
      source      = "hashicorp/aws"
      version     = ">=4.8, ~>5.16"
    }
    # kubectl = {
    #   source  = "gavinbunney/kubectl"
    #   version = ">= 1.7.0"
    # }
  
  }
  backend "s3" {
  bucket  = "avertra-iac-state"
  key     = "Infra/dev/terraform.tfstate"
  region  = "us-east-1"
  dynamodb_table = "tfstate_lock_dynamodb-avertra"
  profile = "default"
  }
}
provider "aws" {
  region = "us-east-1"
  alias  = "default"
  default_tags {
    tags = {
      "kubernetes.io/cluster/demo-eks" = "owned"
    }
  }
}

# provider "helm" {
#   kubernetes {
#     host                   = module.eks.endpoint
#     cluster_ca_certificate = base64decode(module.eks.certificate_authority)

#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       command     = "aws"
#       # This requires the awscli to be installed locally where Terraform is executed
#       args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
#     }
#   }
# }

# provider "kubectl" {
#   apply_retry_count      = 5
#   host                   = module.eks.endpoint
#   cluster_ca_certificate = base64decode(module.eks.certificate_authority)
#   load_config_file       = false

#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     # This requires the awscli to be installed locally where Terraform is executed
#     args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
#   }
# }
provider "kubernetes" {
  config_path = "~/.kube/config" # Adjust this as necessary for your Kubernetes setup
}

data "aws_availability_zones" "available" {}


locals {
  name   = "avertra-project"
  region = "us-east-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}

####################################################################
module "eks" {
  source = "../../modules/eks"

}

# module "eks" {
#   source = "../../modules/k8s"

# }

##############################################
#               metrics-api                  #
##############################################
module "metrics-api" {
  source = "../../modules/metrics-api"

  deploy_metrics = true
  depends_on = [ module.eks ]
}

##############################################
#                aws-auth-cm                 #
##############################################

data "aws_caller_identity" "current" {}

resource "kubernetes_manifest" "aws_auth_configmap" {
  depends_on = [ module.eks ]

  manifest = {
    apiVersion = "v1"
    kind       = "ConfigMap"
    metadata = {
      name      = "aws-auth"
      namespace = "kube-system"
    }
    data = {
      mapRoles = yamlencode([
        {
          rolearn  = "arn:aws:iam::381492099394:role/eks-demo-node"
          username = "system:node:{{EC2PrivateDNSName}}"
          groups   = [
            "system:bootstrappers",
            "system:nodes"
          ]
        }
      ])
    }
  }
}