# Application Assessment

This repository contains Terraform scripts for provisioning infrastructure on AWS and setting up a CI/CD pipeline using CircleCI. 

The infrastructure includes a custom VPC with public and private subnets across multiple availability zones for high availability, an Auto Scaling Group (ASG) to launch Docker hosts (EC2 instances), and a Load Balancer (ELB or ALB) to distribute traffic across the Docker hosts.

## Getting Started

Before getting started, make sure you have this ready:

- Install Terraform or use the terraform cloud
- Configure AWS credentials for Terraform.
- Register on CircleCI using GitHub

## Stages:

- Stage 1: [Provisioning of Instracture Using Terraform]([url](https://github.com/Gbengard/application-assessment-repo/blob/main/Stage-1.md)https://github.com/Gbengard/application-assessment-repo/blob/main/Stage-1.md)
- Stage 2: [CI/CD Pipeline using CircleCI]([url](https://github.com/Gbengard/application-assessment-repo/blob/main/Stage-2.md)https://github.com/Gbengard/application-assessment-repo/blob/main/Stage-2.md)
- Stage 3: CleanUp
