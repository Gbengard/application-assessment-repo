provider "aws" {
  region = var.region
}

# Create VPC
resource "aws_vpc" "cloudhight-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "cloudhight-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.cloudhight-vpc.id
}

# Create Subnets
resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.cloudhight-vpc.id
  cidr_block        = var.public_subnet_a_cidr
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-subnet-a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_vpc.cloudhight-vpc.id
  cidr_block        = var.public_subnet_b_cidr
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public-subnet-b"
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.cloudhight-vpc.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = "${var.region}a"
  tags = {
    Name = "private-subnet-a"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.cloudhight-vpc.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = "${var.region}b"
  tags = {
    Name = "private-subnet-b"
  }
}

# Create NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_a.id
}

# Create Route Tables
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.cloudhight-vpc.id

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.cloudhight-vpc.id

  tags = {
    Name = "private-route-table"
  }
}

# Create Route Table Associations
resource "aws_route_table_association" "public_subnet_a_association" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_b_association" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_a_association" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_b_association" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route_table.id
}

# Create Routes
resource "aws_route" "internet_gateway_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route" "nat_gateway_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

# Create a security group for the application load balancer
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Security group for Application Load Balancer"
  vpc_id   = aws_vpc.cloudhight-vpc.id
  
  # Allow traffic on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a target group for the application load balancer
resource "aws_lb_target_group" "target_group" {
  name     = "target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.cloudhight-vpc.id
  
  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}

# Create an application load balancer
resource "aws_lb" "alb" {
  name               = "application-load-balancer"
  internal           = false
  load_balancer_type = "application"
  
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_a.id, aws_subnet.public_subnet_b.id]
  
  enable_deletion_protection = false
  
  tags = {
    Name = "application-load-balancer"
  }
}

# Create a listener for the application load balancer
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# Create a security group for the launch template
resource "aws_security_group" "launch_template_sg" {
  name        = "launch-template-security-group"
  description = "Security group for Launch Template"
  vpc_id   = aws_vpc.cloudhight-vpc.id
  # Allow traffic from the application load balancer on port 80
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  
  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a launch template for EC2 instances
resource "aws_launch_template" "ec2_launch_template" {
  name_prefix   = "ec2-launch-template-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  user_data     = base64encode(file(var.user_data_script_path))
  
  # Network interface settings
  network_interfaces {
    security_groups = [aws_security_group.launch_template_sg.id]  # Use the security group ID here
  }

  monitoring {
    enabled = true
  }
  tag_specifications  {
    resource_type = "instance"
    tags = {
      Name = "Cloudhight-Server"
    }
  }
}

# Create an autoscaling group
resource "aws_autoscaling_group" "asg" {
  name                 = "autoscaling-group"
  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }
  
  min_size             = 1
  desired_capacity     = 2
  max_size             = 3
  vpc_zone_identifier  = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]

  # Use the security group from the launch template
  target_group_arns    = [aws_lb_target_group.target_group.arn]
  health_check_type    = "ELB"
  termination_policies = ["OldestInstance"]
  metrics_granularity = "1Minute"
}
