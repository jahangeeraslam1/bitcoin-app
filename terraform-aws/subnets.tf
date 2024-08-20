resource "aws_subnet" "private_zone1" {
  vpc_id            = aws_vpc.mainVPC.id # attach subnets to VPC
  cidr_block        = "10.0.0.0/19"
  availability_zone = local.zone1

  tags = {
    "Name"                               = "${local.env}-privateSubnet-${local.zone1}"
    "kubernetes.io/cluster/internal-elb" = "1" #special tag used by EKS and K8 to know to use this subnet for internal load balancers
  }

}

resource "aws_subnet" "private_zone2" {
  vpc_id            = aws_vpc.mainVPC.id # attach subnets to VPC
  cidr_block        = "10.0.32.0/19"
  availability_zone = local.zone2

  tags = {
    "Name"                               = "${local.env}-privateSubnet-${local.zone2}"
    "kubernetes.io/cluster/internal-elb" = "1" #special tag used by EKS and K8 to know to use this subnet for internal load balancers
  }

}

resource "aws_subnet" "public_zone1" {
  vpc_id                  = aws_vpc.mainVPC.id # attach subnets to VPC
  cidr_block              = "10.0.64.0/19"
  availability_zone       = local.zone1
  map_public_ip_on_launch = true

  tags = {
    "Name"                   = "${local.env}-publicSubnet-${local.zone1}"
    "kubernetes.io/role/elb" = "1" #special tag so K8 knows to only use those sunbnets for external load balancers
  }

}

resource "aws_subnet" "public_zone2" {
  vpc_id                  = aws_vpc.mainVPC.id # attach subnets to VPC
  cidr_block              = "10.0.96.0/19"
  availability_zone       = local.zone2
  map_public_ip_on_launch = true

  tags = {
    "Name"                   = "${local.env}-publicSubnet-${local.zone2}"
    "kubernetes.io/role/elb" = "1" #special tag so K8 knows to only use those sunbnets for external load balancers
  }

}