resource "aws_vpc" "my_vpc" {
  cidr_block = "10.20.0.0/16"
  tags = {
    Name = "tf-vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = var.az
  map_public_ip_on_launch = true
  tags = {
    Name = "tf-subnet-public"
  }
}

resource "aws_subnet" "my_subnet_private" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.20.2.0/24"
  availability_zone       = var.az
  map_public_ip_on_launch = false
  tags = {
    Name = "tf-subnet-private"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "gate" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.my_subnet.id
  depends_on    = [aws_internet_gateway.my_igw]
  tags = {
    Name = "nty"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "tf-igw"
  }
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "tf-rt-public"
  }
}

resource "aws_route_table" "my_route_table_private" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "tf-rt-private"
  }
}

resource "aws_route" "my_route" {
  route_table_id         = aws_route_table.my_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route" "my_route_private" {
  route_table_id         = aws_route_table.my_route_table_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gate.id
}

resource "aws_route_table_association" "my_link" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_route_table_association" "my_link_private" {
  subnet_id      = aws_subnet.my_subnet_private.id
  route_table_id = aws_route_table.my_route_table_private.id
}
