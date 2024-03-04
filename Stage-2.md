# CircleCI Configuration

Make Sure You Register CircleCI with your GitHub account.  Then follow the repository of your desired project. Doing this, will automatically trigger the CircleCI anytime there is new commit in the project.

Also, make sure you set the credentials for AWS CLI, DockerHub by going to "Organization Settings", then "Context", and click on "Create COntext"

Let's delve into the details of the CircleCI configuration file (`config.yml`) provided:

#### Version and Orbs

- **Version**: The configuration file starts with the declaration of the CircleCI version being used. In this case, it's `2.1`, which indicates the version 2.1 of CircleCI's configuration syntax.
  
- **Orbs**: Orbs are packages of YAML configuration for CircleCI. They provide reusable and shareable sets of commands, executors, and jobs. In this configuration, the `aws-sam-serverless` orb is imported at version `3.1.0`, which allows for seamless integration with AWS SAM (Serverless Application Model).

#### Commands

- **Install-Dependencies Command**: Custom commands can be defined to encapsulate sequences of steps that are reused across multiple jobs. In this configuration, the `install-dependencies` command is defined to install AWS CLI and configure it with credentials, as well as to install JQ for JSON processing.

#### Jobs

- **Build-and-Push Job**: This job is defined to build a Docker image of the application and push it to Docker Hub. It runs on a machine executor to have direct access to the Docker daemon. The job includes steps to checkout the code, build the Docker image, scan it for security vulnerabilities using Aqua Security's Trivy tool, and push the image to Docker Hub.

- **AWS-CLI Job**: This job configures AWS CLI, creates user data for EC2 instances, appends Docker run commands, and creates a new version of a launch template for EC2 instances. It runs on a Docker executor using the `amazon/aws-cli` image.

  - **Checkout**: This step checks out the code from the repository to the CircleCI environment.
  
  - **Install-Dependencies**: This step executes the `install-dependencies` command defined earlier, which installs AWS CLI, configures it with credentials, and installs JQ for JSON processing.

  - **Create Userdata, Append Docker run command, and Create Launch Template Version**: This step creates a Bash script (`userdata.sh`) containing instructions to update packages, install Docker, add the current user to the Docker group, and restart Docker service. It then appends commands to pull the Docker image from Docker Hub and run it on port 80 to the userdata script. Next, it base64 encodes the userdata script and retrieves the launch template name using AWS CLI and JQ. Finally, it creates a new version of the launch template with the updated userdata.

  - **Update to the Launch Template Version Created**: This step updates the default version of the launch template to the latest version created in the previous step.

  - **Configure Autoscaling group to use the Updated Launch Template Version**: This step retrieves the name of the autoscaling group using AWS CLI, then triggers an instance refresh to apply the changes in the launch template to the autoscaling group.

#### Workflows

- **The_Jobs Workflow**: Workflows define the sequence and dependencies of jobs. In this configuration, the `the_jobs` workflow orchestrates the execution of the defined jobs. 
  - The `build-and-push` job is executed first, which builds the Docker image and pushes it to Docker Hub.
  - After the successful completion of the `build-and-push` job, the `aws-cli` job is triggered, which configures AWS CLI, updates the launch template, and configures the auto-scaling group.

### Conclusion

The CircleCI configuration file orchestrates the CI/CD pipeline for the demo project, from building and pushing Docker images to AWS infrastructure configuration. It utilizes custom commands, jobs, and workflows to automate the process efficiently.

### Stages:

- Stage 1: [Provisioning of Instracture Using Terraform](https://github.com/Gbengard/application-assessment-repo/blob/main/Stage-1.md)
- Stage 2: [CI/CD Pipeline using CircleCI](https://github.com/Gbengard/application-assessment-repo/blob/main/Stage-2.md) <=== Here
- Stage 3: CleanUp
