provider "aws" {
  region = var.region
}

#Creating VPC
resource "aws_vpc" "test_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "Project-AWST-VPC"
  }
}

#Creating Subnets and enabling public ip assgining
resource "aws_subnet" "subnets" {
  count                   = length(var.subnets_cidr_block)
  cidr_block              = var.subnets_cidr_block[count.index]
  vpc_id                  = aws_vpc.test_vpc.id
  availability_zone       = var.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Project-AWST-Subnet-${count.index + 1}"
  }
}

#Creating Internet Gateway for internet access
resource "aws_internet_gateway" "AIGW" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "Project-AWST-IGW"
  }
}

#Creating Route table and associating it with IGW
resource "aws_route_table" "ART" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.AIGW.id
  }

  tags = {
    Name = "Project-AWST-RT"
  }
}

#Associating Route Table to Subnets
resource "aws_route_table_association" "RTA" {
  count          = length(aws_subnet.subnets)
  route_table_id = aws_route_table.ART.id
  subnet_id      = aws_subnet.subnets[count.index].id
}


#Creating Security group
resource "aws_security_group" "SG" {
  name   = "AWST-SG"
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    Name = "Project-AWST-SG"
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access to the instance"
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow internet access to the instance"
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1" #Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}