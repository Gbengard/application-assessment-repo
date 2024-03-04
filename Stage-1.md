# Terraform AWS Infrastructure Provisioning

This repository contains Terraform scripts to provision infrastructure on AWS using the specified template.

## Prerequisites

Before you begin, ensure you have:

- An AWS account with appropriate permissions.
- Terraform installed on your local machine or use Terraform Cloud.
- AWS credentials configured on your machine for Terraform or Terraform Cloud to access AWS services.

## Usage

For Terraform CLI:

1. Clone this repository:

    ```bash
    git clone gbengard/application-assessment-repo
    ```

2. Navigate to the directory containing the Terraform scripts.

3. Customize the Terraform variables as required in the Terraform script.

4. Run the following commands to initialize Terraform and apply the changes:

    ```bash
    terraform init
    terraform apply
    ```

5. Review the planned actions and confirm by typing `yes` when prompted.

6. Once Terraform has successfully applied the changes, your AWS infrastructure will be provisioned according to the defined template.


For Terraform Cloud using Version Control Workflow:

1.	Click on "New", choose workspace
2.	Click on "Version Control Workflow", then choose "Github", then click on "github.com"

images

3. Click on "Authorize", to install Github

Images

4.	Input your github details.

5.	Input the workspace name

6. Make sure you set the "Terraform Working Directory", as for this project that will be '/terraform/'

7.	Check both Auto-apply API, CLI, & VCS runs and Auto-apply run triggers under the "auto-apply section"

8.	Under the VCS Triggers, check the "Always trigger runs"

9.  Input the branch your terraform reside in.

10.	Then click on "Create".

12.	Click on "Start New Plan", and click on "Start". This will create the resources.

    Images

    Images


## Template Overview

Sure, let's break down the Terraform template you've provided:

1. **Provider Configuration**: 
   - `provider "aws"`: Configures Terraform to use the AWS provider plugin. It specifies the AWS region as `us-east-1`.

2. **VPC (Virtual Private Cloud) Creation**: 
   - `resource "aws_vpc" "cloudhight-vpc"`: Creates a VPC named "cloudhight-vpc" with the CIDR block `10.16.0.0/24`.

3. **Internet Gateway Creation**: 
   - `resource "aws_internet_gateway" "gw"`: Creates an internet gateway and attaches it to the VPC created earlier.

4. **Subnet Creation**: 
   - Creates four subnets (two public and two private) within the VPC, each spanning a different availability zone (`us-east-1a` and `us-east-1b`). 
   - Public subnets have `map_public_ip_on_launch` set to true, allowing instances launched in these subnets to have public IP addresses.

5. **NAT Gateway Creation**: 
   - `resource "aws_eip" "nat_eip"`: Allocates an Elastic IP (EIP) for use with the NAT Gateway.
   - `resource "aws_nat_gateway" "nat_gateway"`: Creates a NAT Gateway and associates it with one of the public subnets to provide internet access to instances in the private subnets.

6. **Route Tables**: 
   - Creates separate route tables for the public and private subnets.

7. **Route Table Associations**: 
   - Associates each subnet with its respective route table.

8. **Routes**: 
   - Configures routes in the route tables to direct traffic. 
   - Public subnets route traffic to the internet gateway.
   - Private subnets route traffic through the NAT Gateway.

9. **Security Groups**: 
   - `aws_security_group` resources define security groups for the Application Load Balancer (ALB) and launch template instances.
   - The ALB security group allows inbound traffic on port 80 from anywhere and allows all outbound traffic.
   - The launch template security group allows inbound traffic on port 80 only from the ALB security group and allows all outbound traffic.

10. **Application Load Balancer (ALB)**: 
    - `resource "aws_lb"`: Creates an Application Load Balancer in the specified subnets, with the associated security group.

11. **Target Group**: 
    - `resource "aws_lb_target_group"`: Creates a target group for the ALB to route traffic to.

12. **ALB Listener**: 
    - `resource "aws_lb_listener"`: Creates a listener for the ALB to listen on port 80 and forward traffic to the target group.

13. **Launch Template**: 
    - `resource "aws_launch_template"`: Defines a launch template for EC2 instances, specifying the AMI, instance type, user data script, security group, and tags.

14. **Autoscaling Group (ASG)**: 
    - `resource "aws_autoscaling_group"`: Creates an autoscaling group using the launch template, specifying the minimum, maximum, and desired capacity, as well as the subnets and target group for the instances.

This Terraform template automates the setup of a basic AWS infrastructure, including VPC, subnets, NAT Gateway, route tables, security groups, Application Load Balancer, launch template, and autoscaling group. It provides a scalable and resilient architecture for hosting applications in AWS.

**Happy provisioning!**

## Checking the Provisioned Infrastructure

1. Using the Terraform Cloud, all 23 resources were fully created

    Images

2. Go to running "EC2 Instaces", there are 2 instances in the private subnet currently running.

   Images

3. Go to "Target Group", the two instances are healthy.

    Images
   
5. Go to "Application Load Balancer", copy the DNS Name, paste on your browser. It should be running an Nginx Server.

    Images

## Stages:

- Stage 1: [Provisioning of Instracture Using Terraform](https://github.com/Gbengard/application-assessment-repo/blob/main/Stage-1.md) <===Here
- Stage 2: [CI/CD Pipeline using CircleCI](https://github.com/Gbengard/application-assessment-repo/blob/main/Stage-2.md)
- Stage 3: CleanUp
