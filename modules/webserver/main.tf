resource "aws_instance" "instancia-curso-aws" {
  ami           = var.ami_id
  instance_type = var.instance_type

  credit_specification {
    cpu_credits = "unlimited"
  }

  # Asociamos el par de claves que ya teníamos creado
  key_name = var.key_pair_name

  # Asociamos el grupo de seguridad a la instancia
  vpc_security_group_ids = [aws_security_group.http-server-terraform.id]
}

# Creamos un grupo de seguridad para la instancia
resource "aws_security_group" "http-server-terraform" {
  name        = "http-server-terraform"
  description = "Allow HTTP(s) and SSH inbound traffic"

  ingress {
    description      = "TLS from the Internet"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP from the Internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH from the Internet"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
