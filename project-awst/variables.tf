variable "region" {
  default = "ap-south-1"
  description = "Region in which infra will be deployed"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "subnets_cidr_block" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
  description = "List of CIDR blocks for subnets"
}

variable "availability_zone" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
  description = "List of AZ for subnets and EC2 to be deployed"
}


variable "ami" {
  default = "ami-053b12d3152c0cc71"
  description = "AMI ID which will be used."
}

variable "instance_type" {
  default = "t2.micro"
  description = "EC2 instance type"
}

variable "key_pair" {
  default = "C:\\Users\\HP VICTUS\\.ssh\\id_ed25519.pub"
  description = "Path to the SSH public key file"
  
}