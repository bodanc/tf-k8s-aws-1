data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc0" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    name       = "vpc0"
    created_by = "terraform"
  }
}

resource "aws_internet_gateway" "igw0" {
  vpc_id = aws_vpc.vpc0.id

  tags = {
    name       = "igw0"
    created_by = "terraform"
  }
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

  tags = {
    name       = "rtb-public"
    created_by = "terraform"
  }
}

resource "aws_route_table" "rtb-private" {
  vpc_id = aws_vpc.vpc0.id

  route {
    cidr_block = aws_vpc.vpc0.cidr_block
    gateway_id = "local"
  }

  tags = {
    name       = "rtb-private"
    created_by = "terraform"
  }
}

resource "aws_subnet" "subnet-private0" {
  vpc_id     = aws_vpc.vpc0.id
  cidr_block = "10.0.0.0/18"

  availability_zone = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = false

  tags = {
    name       = "subnet-private0"
    created_by = "terraform"
  }
}

resource "aws_subnet" "subnet-public0" {
  vpc_id = aws_vpc.vpc0.id
  cidr_block = "10.64.0.0/18"

  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    name       = "subnet-public0"
    created_by = "terraform"
  }

}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.subnet-private0.id
  route_table_id = aws_route_table.rtb-private.id
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.subnet-public0.id
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

# resource "aws_security_group" "secgr0" {
  
# }
