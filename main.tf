provider "aws" {
  region = var.region
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP(S) and SSH traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.web_sg.name]

  root_block_device {
    volume_size = var.volume_size  
    volume_type = "gp2"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install docker.io -y
              sudo systemctl start docker
              sudo usermod -aG docker ubuntu
              sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose
              sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
              sudo apt install git -y
              EOF

  tags = {
    Name = "docker-terraform-ec2"
  }
}

output "instance_ip" {
  value = aws_instance.web.public_ip
}