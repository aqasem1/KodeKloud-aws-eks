############################################################33
variable "cidr" {
  type        = string
  description = "The CIDR block for the VPC"
}
variable "azs" {
  type        = list(string)
  description = "a list contain the avilable AZs inside the region we apply in it"
}
variable "database_subnets" {
  type        = list(string)
  description = "list of database private subnets in the vpc"
}
variable "private_subnets" {
  type        = list(string)
  description = "list of  private subnets in the vpc"
}
variable "public_subnets" {
  type        = list(string)
  description = "list of public subnets in the vpc"
}

############################################################33

# KK Playground. Cluster must be called 'demo-eks'
variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
  default     = "demo-eks"
}

# KK Playground. Cluster role must be called 'eksClusterRole'
variable "cluster_role_name" {
  type        = string
  description = "Name of the cluster role"
  default     = "eksClusterRole"
}

# KK Playground. Node role must be called 'eks-demo-node'
variable "node_role_name" {
  type        = string
  description = "Name of node role"
  default     = "eks-demo-node"
}

variable "node_group_desired_capacity" {
  type        = number
  description = "Desired capacity of Node Group ASG."
  default     = 1
}
variable "node_group_max_size" {
  type        = number
  description = "Maximum size of Node Group ASG. Set to at least 1 greater than node_group_desired_capacity."
  default     = 3
}

variable "node_group_min_size" {
  type        = number
  description = "Minimum size of Node Group ASG."
  default     = 1
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
