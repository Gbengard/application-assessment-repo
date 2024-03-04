# CleanUp

Let's destroy the infrastructure created using terraform

For Terraform CLI:

	Type 'terraform destroy --auto-approve' on your local machine.

For Terraform Cloud:
1.	Go to your workspace
2.	Click on Destruction and Deletion
3.	Click on "Queue Destroy Plan", enter the workspace name to confirm
	
	![Untitled](/images/Untitled13.png)

4. Click on "Queue Destroy Plan"
5. 23 Resources were successfuly Destroyed

	![Untitled](/images/Untitled14.png)

For CircleCI:

1. Click on Projects on your dashboard
2. Locate the project you are currently following and Click on the ""Unfollow Project"
	
	![Untitled](/images/Untitled15.png)


 For further details and stages of the project, refer to the following:

- Stage 1: [Provisioning of Infrastructure Using Terraform](https://github.com/Gbengard/application-assessment-repo/blob/main/Stage-1.md)
- Stage 2: [CI/CD Pipeline using CircleCI](https://github.com/Gbengard/application-assessment-repo/blob/main/Stage-2.md)
- Stage 3: [CleanUp](https://github.com/Gbengard/application-assessment-repo/blob/main/Stage-3.md) <=== Here
