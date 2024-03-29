# VPC
# Subnets
# Internet Gateway
# Route Table

resource "aws_vpc" "tf_eks_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name                                        = "${var.namespace}-vpc",
    "kubernetes.io/cluster/${var.cluster_name}" = "shared",
  }
}

resource "aws_subnet" "tf_eks_subnet" {
  count = length(data.aws_availability_zones.available.names)

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(var.cidr_block, 4, count.index + 1)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.tf_eks_vpc.id

  tags = {
    Name                                        = "${var.namespace}-subnet",
    "kubernetes.io/cluster/${var.cluster_name}" = "shared",
  }
}

resource "aws_internet_gateway" "tf_eks_gw" {
  vpc_id = aws_vpc.tf_eks_vpc.id

  tags = {
    Name = "${var.namespace}-gw"
  }
}

resource "aws_route_table" "tf_eks_routetable" {
  vpc_id = aws_vpc.tf_eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_eks_gw.id
  }
}

resource "aws_route_table_association" "tf_eks_assoc" {
  count = length(data.aws_availability_zones.available.names)

  subnet_id      = aws_subnet.tf_eks_subnet.*.id[count.index]
  route_table_id = aws_route_table.tf_eks_routetable.id
}