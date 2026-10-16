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
# 1. Custom VPC
resource "aws_vpc" "main_vpc" {
 cidr_block = "10.0.0.0/16"
 tags = {
 Name = "three-tier-vpc"
 }
}
# 2. Internet Gateway
resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main_vpc.id
 tags = {
 Name = "three-tier-igw"
 }
}
# 3. Public Subnet
resource "aws_subnet" "public_subnet" {
 vpc_id = aws_vpc.main_vpc.id
 cidr_block = "10.0.1.0/24"
 map_public_ip_on_launch = true
 tags = {
 Name = "three-tier-public-subnet"
 }
}
# 4. Route Table
resource "aws_route_table" "public_rt" {
 vpc_id = aws_vpc.main_vpc.id
 route {
 cidr_block = "0.0.0.0/0"
 gateway_id = aws_internet_gateway.gw.id
 }
tags = {
 Name = "three-tier-public-rt"
 }
}
# 5. Route Table Association
resource "aws_route_table_association" "rta" {
 subnet_id = aws_subnet.public_subnet.id
 route_table_id = aws_route_table.public_rt.id
}
# 6. Security Group (Allow SSH and HTTP)
resource "aws_security_group" "sec_group" {
 name = "three-tier-sg"
 description = "Allow SSH and HTTP inbound traffic"
 vpc_id = aws_vpc.main_vpc.id
 ingress {
 description = "SSH"
 from_port = 22
 to_port = 22
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
 ingress {
 description = "HTTP"
 from_port = 80
 to_port = 80
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
 from_port = 0
 to_port = 0
 protocol = "-1"
 cidr_blocks = ["0.0.0.0/0"]
 }
 tags = {
 Name = "three-tier-sg"
 }
}
# 7. EC2 Instance (Free-Tier Eligible Ubuntu t2.micro)
resource "aws_instance" "app_server" {
 ami = "ami-xxxxxxxx" # Ubuntu 22.04 LTS (eu-north-1)
 instance_type = "t3.micro"
 subnet_id = aws_subnet.public_subnet.id
 vpc_security_group_ids = [aws_security_group.sec_group.id]
 key_name = "your-key-pair-name" 
 tags = {
 Name = "three-tier-ec2-instance"
 }
}