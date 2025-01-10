#Creating keys for ssh
resource "aws_key_pair" "sshKey" {
  key_name   = "awst_KP"
  public_key = file(var.key_pair)
}

#Creating S3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = "awst-project-bucket-2024-${var.region}"
  tags = {
    Description = "Terraform bucket to keep some files stored"
    Environment = "DEV"
  }
}
/*
#Putting one file in S3 Bucket
resource "aws_s3_object" "putObject" {
  bucket = aws_s3_bucket.mybucket.id
  source = "user_data.sh"
  key = "user_data.sh"
}
*/
#Putting multiple file in S3 Bucket
resource "aws_s3_object" "name" {
  for_each = {
    "user_data.sh"  = "user_data.sh",
    "user_data1.sh" = "user_data1.sh"
  }
  source = each.key
  key    = each.key
  bucket = aws_s3_bucket.mybucket.id
}

#Creating EC2 Instance
resource "aws_instance" "ec2_instance" {
  count                  = length(aws_subnet.subnets)
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnets[count.index].id
  vpc_security_group_ids = [aws_security_group.SG.id]
  tags = {
    Name = "Project-AWST-Instance-${count.index + 1}"
  }
  key_name = aws_key_pair.sshKey.id

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  # Pass availability_zone variable to the user_data script
  user_data = templatefile("aws_install.sh", {
    bucket            = aws_s3_bucket.mybucket.bucket
    availability_zone = var.availability_zone[count.index]
  })

  /* #The templatefile function reads the contents of aws_install.sh and replaces ${bucket} 
   with the actual bucket name (aws_s3_bucket.mybucket.bucket).

   user_data = templatefile("aws_install.sh", {
    bucket = aws_s3_bucket.mybucket.bucket
  })*/

}

#Creating Application load Balancer
resource "aws_lb" "load_bal" {
  name               = "awst-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SG.id]
  subnets            = aws_subnet.subnets[*].id

  tags = {
    Name = "Project-AWST-ALB"
  }
}

#Creating Target Group
resource "aws_lb_target_group" "alb-tg" {
  name     = "awst-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.test_vpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
  tags = {
    Name = "Project-AWST-TG"
  }
}

#Attaching EC2 instances to TG
resource "aws_lb_target_group_attachment" "alb_tga" {
  for_each         = { for idx, instance in aws_instance.ec2_instance : idx => instance }
  target_group_arn = aws_lb_target_group.alb-tg.arn
  target_id        = each.value.id
  port             = 80
}

#Attaching LB to TG adn forward the traffic to instances
resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.load_bal.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.alb-tg.arn
    type             = "forward"
  }
}

output "instance_public_ips" {
  value = aws_instance.ec2_instance[*].public_ip
}

output "lb_dns" {
  value = aws_lb.load_bal.dns_name
}
