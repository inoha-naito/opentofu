resource "aws_security_group" "example_ec2_sg" {
  name        = "example-ec2-sg"
  description = "EC2 Security Group"
  vpc_id      = aws_vpc.example_vpc.id

  tags = {
    Name = "example-ec2-sg"
  }
}

resource "aws_security_group_rule" "example_ec2_in_http" {
  security_group_id = aws_security_group.example_ec2_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "example_ec2_out" {
  security_group_id = aws_security_group.example_ec2_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

resource "aws_instance" "example_ec2" {
  instance_type = "t2.micro"
  ami           = data.aws_ssm_parameter.al2023_ami.value
  subnet_id     = aws_subnet.example_subnet_a.id
  vpc_security_group_ids = [
    aws_security_group.example_ec2_sg.id,
  ]
  user_data = <<EOF
#!/bin/bash
yum update -y
yum install -y httpd
uname -n > /var/www/html/index.html
systemctl start httpd
systemctl enable httpd
EOF

  tags = {
    Name = "example-ec2"
  }
}
