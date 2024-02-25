resource "aws_vpc" "example_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_subnet" "example_public_subnet_a" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "example-public-subnet-a"
  }
}

resource "aws_subnet" "example_private_subnet_a" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "example-private-subnet-a"
  }
}

resource "aws_subnet" "example_private_subnet_c" {
  vpc_id                  = aws_vpc.example_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "example-private-subnet-c"
  }
}

resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "example-igw"
  }
}

resource "aws_route_table" "example_public_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "example-public-route-table"
  }
}

resource "aws_route" "example_route" {
  route_table_id         = aws_route_table.example_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.example_igw.id
}

resource "aws_route_table_association" "example_public_route_table_a" {
  route_table_id = aws_route_table.example_public_route_table.id
  subnet_id      = aws_subnet.example_public_subnet_a.id
}

resource "aws_route_table" "example_private_route_table" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "example-private-route-table"
  }
}

resource "aws_route_table_association" "example_private_route_table_a" {
  route_table_id = aws_route_table.example_private_route_table.id
  subnet_id      = aws_subnet.example_private_subnet_a.id
}

resource "aws_route_table_association" "example_private_route_table_c" {
  route_table_id = aws_route_table.example_private_route_table.id
  subnet_id      = aws_subnet.example_private_subnet_c.id
}
