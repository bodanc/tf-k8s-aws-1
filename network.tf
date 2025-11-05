data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc0" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(local.tags_common, { name = lower("${local.prefix}-vpc0") })
}

resource "aws_internet_gateway" "igw0" {
  vpc_id = aws_vpc.vpc0.id

  tags = merge(local.tags_common, { name = lower("${local.prefix}-igw0") })
}

resource "aws_route_table" "rtb-public" {
  vpc_id = aws_vpc.vpc0.id

  route {
    cidr_block = aws_vpc.vpc0.cidr_block
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw0.id
  }

  tags = merge(local.tags_common, { name = lower("${local.prefix}-rtb-pub") })

}

resource "aws_route_table" "rtb-private" {
  vpc_id = aws_vpc.vpc0.id

  route {
    cidr_block = aws_vpc.vpc0.cidr_block
    gateway_id = "local"
  }

  tags = merge(local.tags_common, { name = lower("${local.prefix}-rtb-priv") })
}

resource "aws_subnet" "subnet-private0" {
  vpc_id     = aws_vpc.vpc0.id
  cidr_block = "10.0.0.0/18"

  availability_zone = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = false

  tags = merge(local.tags_common, { name = lower("${local.prefix}-sub-priv0") })
}

resource "aws_subnet" "subnet-public0" {
  vpc_id     = aws_vpc.vpc0.id
  cidr_block = "10.64.0.0/18"

  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(local.tags_common, { name = lower("${local.prefix}-sub-pub0") })

}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.subnet-private0.id
  route_table_id = aws_route_table.rtb-private.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.subnet-public0.id
  route_table_id = aws_route_table.rtb-public.id
}

# resource "aws_network_acl" "nacl0" {
#   vpc_id = aws_vpc.vpc0

#   egress {
#     protocol = 
#   }

#   ingress {
#   }
# }

resource "aws_security_group" "sec-gr-k8s" {
  name   = lower("${local.prefix}-sec-gr-k8s")
  vpc_id = aws_vpc.vpc0.id

  # ingress {
  #   ...
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags_common

}
