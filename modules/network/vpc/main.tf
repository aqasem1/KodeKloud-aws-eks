module "vpc" {
  source        = "terraform-aws-modules/vpc/aws"
  version       = "~> 5.1.2"
  name          = var.name
  cidr          = var.cidr

  azs                     = var.azs
  private_subnets         = var.private_subnets
  public_subnets          = var.public_subnets
  database_subnets        = var.database_subnets

  enable_dns_hostnames                = true
  default_security_group_egress =[]
  default_security_group_ingress = []

  # configure nat gatway
  enable_nat_gateway            = true
  single_nat_gateway            = true
  create_database_subnet_group  = true

  tags = merge(
  {
    Name                 = "${var.project_name}-${var.infra_env}-vpc"
    Application          = "AWS VPC"
    Application_Role     = "virtual network"
    Environment          = var.infra_env
    ManagedBy            = "Terraform"

  },
  )
}

#################################################
