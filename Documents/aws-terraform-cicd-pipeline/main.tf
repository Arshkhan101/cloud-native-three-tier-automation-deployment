terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.69.1"
    }
  }
}
provider "aws" {
  region = "eu-north-1" 
}

# 1. Default VPC 
data "aws_vpc" "default"{
  default = true
}

# 2. Security Group (SSH aur HTTP allow karne ke liye)
resource "aws_security_group" "flask_sg" {
  name        = "ec2-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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
    Name = "ec2-SG"
  }
}

# 3. Free-tier eligible Ubuntu t3.micro EC2 Instance 
resource "aws_instance" "web_server" {
  ami           = "ami-0aba19e56f3eaec05" # Ubuntu (eu-north-1)
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.flask_sg.id]

  tags = {
    Name = "AWS-Server"
  }
}

output "ec2_public_ip" {
  value       = aws_instance.web_server.public_ip
  description = "Public IP address of the EC2 instance"
}