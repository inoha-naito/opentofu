#privateキーのアルゴリズム設定
resource "tls_private_key" "example_ed25519" {
  algorithm = "RSA"
  rsa_bits = 4098
}

resource "local_sensitive_file" "private_key_pem" {
  filename        = "../../.ssh/aws.pem"
  content         = tls_private_key.example_ed25519.private_key_pem
  file_permission = "0400"
}

// 登録
resource "aws_key_pair" "example_key_pair" {
  key_name   = "example-key-pair"
  public_key = tls_private_key.example_ed25519.public_key_openssh

  tags = {
    Name = "example-key-pair"
  }
}
