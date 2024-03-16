resource "aws_vpc" "myvpc" {
  cidr_block = var.VpcCIDR
  tags = {
    Name = "vprofile-eks"
  }
}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.PubSub1CIDR
  availability_zone       = var.ZONE1
  map_public_ip_on_launch = true
  tags = {
    Name                                 = "Public Subnet1"
    "kubernetes.io/role/elb"             = "1"
    "kubernetes.io/cluster/vprofile-eks" = "owned"
  }

}


resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.PubSub2CIDR
  availability_zone       = var.ZONE2
  map_public_ip_on_launch = true
  tags = {
    Name                                 = "Public Subnet2"
    "kubernetes.io/role/elb"             = "1"
    "kubernetes.io/cluster/vprofile-eks" = "owned"
  }

}
resource "aws_subnet" "sub3" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.PubSub3CIDR
  availability_zone       = var.ZONE3
  map_public_ip_on_launch = true
  tags = {
    Name                                 = "Public Subnet3"
    "kubernetes.io/role/elb"             = "1"
    "kubernetes.io/cluster/vprofile-eks" = "owned"
  }

}

resource "aws_subnet" "sub4" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.PrivSub1CIDR
  availability_zone = var.ZONE1
  tags = {
    Name                                 = "Private Subnet1"
    "kubernetes.io/role/internal-elb"    = "1"
    "kubernetes.io/cluster/vprofile-eks" = "owned"
  }

}
resource "aws_subnet" "sub5" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.PrivSub2CIDR
  availability_zone = var.ZONE2
  tags = {
    Name                                 = "Private Subnet2"
    "kubernetes.io/role/internal-elb"    = "1"
    "kubernetes.io/cluster/vprofile-eks" = "owned"
  }

}
resource "aws_subnet" "sub6" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.PrivSub3CIDR
  availability_zone = var.ZONE3
  tags = {
    Name                                 = "Private Subnet3"
    "kubernetes.io/role/internal-elb"    = "1"
    "kubernetes.io/cluster/vprofile-eks" = "owned"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "IG-Public-&-Private-VPC"
  }
}

resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "RT for IG Public"
  }
}


resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "rta3" {
  subnet_id      = aws_subnet.sub3.id
  route_table_id = aws_route_table.PublicRT.id
}



resource "aws_eip" "nat1" {
  domain = "vpc"
}

resource "aws_nat_gateway" "example1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.sub1.id
  tags = {
    Name = "Nat-Gateway_Project"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "PrivateNAT-RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example1.id
  }
  tags = {
    Name = "Route Table for NAT Gateway"
  }
}

resource "aws_route_table_association" "NAT-Gate-rta1" {
  subnet_id      = aws_subnet.sub4.id
  route_table_id = aws_route_table.PrivateNAT-RT.id
}

resource "aws_route_table_association" "NAT-Gate-rta2" {
  subnet_id      = aws_subnet.sub5.id
  route_table_id = aws_route_table.PrivateNAT-RT.id
}

resource "aws_route_table_association" "NAT-Gate-rta3" {
  subnet_id      = aws_subnet.sub6.id
  route_table_id = aws_route_table.PrivateNAT-RT.id
}
