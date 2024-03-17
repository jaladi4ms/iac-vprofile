resource "aws_vpc" "myvpc" {
  cidr_block = var.VpcCIDR
  tags = {
    Name = "${var.project_name}-vpc"
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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public Route Table"
  }
}


resource "aws_route_table_association" "publicrta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "publicrta2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "publicrta3" {
  subnet_id      = aws_subnet.sub3.id
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_subnet" "sub4" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.PrivSub1CIDR
  availability_zone = var.ZONE1
  tags = {
    Name                                 = "Private Subnet4"
    "kubernetes.io/role/internal-elb"    = "1"
    "kubernetes.io/cluster/vprofile-eks" = "owned"
  }

}
resource "aws_subnet" "sub5" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.PrivSub2CIDR
  availability_zone = var.ZONE2
  tags = {
    Name                                 = "Private Subnet5"
    "kubernetes.io/role/internal-elb"    = "1"
    "kubernetes.io/cluster/vprofile-eks" = "owned"
  }

}
resource "aws_subnet" "sub6" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.PrivSub3CIDR
  availability_zone = var.ZONE3
  tags = {
    Name                                 = "Private Subnet6"
    "kubernetes.io/role/internal-elb"    = "1"
    "kubernetes.io/cluster/vprofile-eks" = "owned"
  }

}

resource "aws_eip" "nat1" {
  domain = "vpc"
}

resource "aws_nat_gateway" "aws_nat_gateway1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.sub1.id
  tags = {
    Name = "${var.project_name}-Nat-Gateway"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "PrivateNAT-RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.aws_nat_gateway1.id
  }
  tags = {
    Name = "${var.project_name}-RT for NAT Gateway"
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
