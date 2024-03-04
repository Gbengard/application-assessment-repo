variable "region" {
  description = "The AWS region where resources will be created."
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  default     = "10.16.0.0/24"
}

variable "public_subnet_a_cidr" {
  description = "CIDR block for public subnet A."
  default     = "10.16.0.0/26"
}

variable "public_subnet_b_cidr" {
  description = "CIDR block for public subnet B."
  default     = "10.16.0.64/26"
}

variable "private_subnet_a_cidr" {
  description = "CIDR block for private subnet A."
  default     = "10.16.0.128/26"
}

variable "private_subnet_b_cidr" {
  description = "CIDR block for private subnet B."
  default     = "10.16.0.192/26"
}

variable "ami_id" {
  description = "The ID of the Amazon Machine Image (AMI) to use for EC2 instances."
  default     = "ami-0c7217cdde317cfec"
}

variable "instance_type" {
  description = "The type of EC2 instances to launch."
  default     = "t2.micro"
}

variable "user_data_script_path" {
  description = "Path to the user data script for EC2 instances."
  default     = "init.sh"
}
