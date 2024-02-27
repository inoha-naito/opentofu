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

resource "aws_route" "example_igw_route" {
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

resource "aws_eip" "example_eip" {
  domain = "vpc"

  tags = {
    Name = "example-eip"
  }
}

resource "aws_nat_gateway" "example_nat" {
  allocation_id = aws_eip.example_eip.id
  subnet_id     = aws_subnet.example_public_subnet_a.id

  tags = {
    Name = "example-nat"
  }
}

resource "aws_route" "example_nat_route" {
  route_table_id         = aws_route_table.example_private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.example_nat.id
}

resource "aws_security_group" "example_lambda_rds_sg" {
  name        = "example-lambda-rds-sg"
  description = "RDS-Lambda Security Group"
  vpc_id      = aws_vpc.example_vpc.id

  tags = {
    Name = "example-lambda-rds-sg"
  }
}

resource "aws_security_group_rule" "example_lambda_rds_out" {
  security_group_id        = aws_security_group.example_lambda_rds_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.example_lambda_rds_sg.id
}

# resource "aws_security_group_rule" "example_lambda_rds_out" {
#   security_group_id = aws_security_group.example_lambda_rds_sg.id
#   type              = "egress"
#   protocol          = "-1"
#   from_port         = 0
#   to_port           = 0
#   cidr_blocks       = ["0.0.0.0/0"]
# }

resource "aws_security_group" "example_rds_lambda_sg" {
  name        = "example-rds-lambda-sg"
  description = "Lambda-RDS Security Group"
  vpc_id      = aws_vpc.example_vpc.id

  tags = {
    Name = "example-rds-lambda-sg"
  }
}

resource "aws_security_group_rule" "example_rds_lambda_in" {
  security_group_id        = aws_security_group.example_rds_lambda_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.example_lambda_rds_sg.id
}
