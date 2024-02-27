resource "aws_security_group" "example_rds_sg" {
  name        = "example-rds-sg"
  description = "RDS Security Group"
  vpc_id      = aws_vpc.example_vpc.id

  tags = {
    Name = "example-rds-sg"
  }
}

resource "aws_security_group_rule" "example_rds_in" {
  security_group_id        = aws_security_group.example_rds_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.example_ec2_sg.id
}

resource "aws_security_group_rule" "example_rds_out" {
  security_group_id = aws_security_group.example_rds_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_db_subnet_group" "example_rds_subnet_group" {
  name       = "example-rds-subnet-group"
  subnet_ids = [aws_subnet.example_private_subnet_a.id, aws_subnet.example_private_subnet_c.id]

  tags = {
    Name = "example-rds-subnet-group"
  }
}

resource "aws_db_instance" "example_rds" {
  storage_type           = "gp2"
  allocated_storage      = 20
  identifier             = "example-rds"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t2.micro"
  username               = "foo"
  password               = "foobarbaz"
  vpc_security_group_ids = [aws_security_group.example_rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.example_rds_subnet_group.id
  publicly_accessible    = true
  skip_final_snapshot    = true

  tags = {
    Name = "example-rds"
  }
}
