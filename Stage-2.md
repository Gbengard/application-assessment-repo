## CircleCI Configuration

To ensure seamless integration and automation of your project's CI/CD pipeline, it's imperative to properly configure CircleCI. Follow these steps to set up CircleCI with your GitHub repository and streamline your workflow efficiently.

### CircleCI Integration

1. **Registration**: Register CircleCI with your GitHub account. This enables the automatic triggering of CircleCI whenever there's a new commit in your project repository.

2. **Repository Follow**: Follow the repository of your desired project on CircleCI to activate automated builds upon new commits.

### Setting Credentials

Ensure proper configuration of credentials for AWS CLI and DockerHub. Access "Organization Settings" on CircleCI, navigate to "Context," and create a new context to securely store these credentials.

### Details of Configuration (`config.yml`)

#### Version and Orbs

- **Version**: Declare the CircleCI version being utilized at the beginning of the configuration file (`2.1` for version 2.1 syntax).
  
- **Orbs**: Import necessary orbs to facilitate integration tasks. For instance, import the `aws-sam-serverless` orb at a specific version (`3.1.0`) to seamlessly interact with AWS services.

#### Custom Commands

Define custom commands to encapsulate reusable sequences of steps across multiple jobs. For instance, the `install-dependencies` command installs AWS CLI, configures credentials, and installs JQ for JSON processing.

#### Jobs

- **Build-and-Push Job**: Define a job to build Docker images of the application and push them to Docker Hub. Utilize a machine executor for direct Docker daemon access. Include steps for code checkout, Docker image build, security vulnerability scanning using Trivy, and image push to Docker Hub.

- **AWS-CLI Job**: Configure AWS CLI, create EC2 user data, append Docker run commands, and update launch templates. Run this job on a Docker executor using the `amazon/aws-cli` image.

  - **Checkout**: Retrieve code from the repository to the CircleCI environment.
  
  - **Install-Dependencies**: Execute the custom `install-dependencies` command for AWS CLI setup and JQ installation.

  - **Userdata Script Creation**: Generate a Bash script (`userdata.sh`) to update packages, install Docker, configure Docker run commands, and create/encode userdata for launch template updates.

  - **Launch Template Versioning**: Create and update launch template versions with the modified user-data script.

  - **Autoscaling Group Configuration**: Update the autoscaling group to utilize the latest launch template version.

#### Workflows

- **The_Jobs Workflow**: Orchestrate job execution sequences and dependencies. Define the `the_jobs` workflow to execute the `build-and-push` job followed by the `aws-cli` job upon successful completion of the former.

### Integration Success Verification

Verify successful integration by checking the following:

1. CircleCI Integration Status.

   ![Untitled](/images/Untitled8.png)

2. Docker Image Pushed to Dockerhub Repository.

   ![Untitled](/images/Untitled9.png)

3. Creation of New Launch Template Version and Automatic Set to Default via CircleCI.

   ![Untitled](/images/Untitled10.png)

4. Autoscaling Group Instance Update to Utilize Latest Launch Template Version.
   
   ![Untitled](/images/Untitled11.png)

5. Refresh the Application Load Balancer DNS to Reflect the Pet-Clinic App.
   
   ![Untitled](/images/Untitled12.png)

### Additional Information

For further details and stages of the project, refer to the following:

- Stage 1: [Provisioning of Infrastructure Using Terraform](https://github.com/Gbengard/application-assessment-repo/blob/main/Stage-1.md)
- Stage 2: [CI/CD Pipeline using CircleCI](https://github.com/Gbengard/application-assessment-repo/blob/main/Stage-2.md) <====Here
- Stage 3: [CleanUp](https://github.com/Gbengard/application-assessment-repo/blob/main/Stage-3.md)

By following these instructions meticulously, you ensure the smooth operation and automation of your project's CI/CD pipeline using CircleCI.
