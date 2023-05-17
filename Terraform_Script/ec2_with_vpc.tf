provider "aws" {
  region = "us-east-1"
}

#ec2 instance
resource "aws_instance" "demo-server" {
  ami           = "ami-0b08bfc6ff7069aff"
  instance_type = "t3.micro"
  count = 2
  key_name = "rtp-03"
  subnet_id =   aws_subnet.demo_subnet.id
  vpc_security_group_ids = [ "aws_security_group.demo-vpc-sg.id" ] 
}

#create vpc
resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.10.0.0/16"
}

#create subnet
resource "aws_subnet" "demo_subnet" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "demo_subnet"
  }
}

#create internet gateway
resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "demo-igw"
  }
}

#create route table
resource "aws_route_table" "demo-rt" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "10.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }

  tags = {
    Name = "demo-rt"
  }
}

#route_table_association
resource "aws_route_table_association" "demo-rt_association" {
  subnet_id      = aws_subnet.demo_subnet.id
  route_table_id = aws_route_table.demo-rt.id
}

#security group
resource "aws_security_group" "demo-vpc-sg" 
  name        = "demo-vpc-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.demo-vpc.id

  ingress {
    description      = "TLS from VPC"
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
    Name = "demo-vpc-sg"
  }
}
