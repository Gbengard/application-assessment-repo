pipeline {
  agent {
    docker {
      image 'abhishekf5/maven-abhishek-docker-agent:v1'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock' // mount Docker socket to access the host's Docker daemon
      environment {
        AWS_CREDENTIALS = credentials('YOUR_AWS_CREDENTIALS_ID')
        AWS_ACCESS_KEY_ID = sh(script: "echo '${AWS_CREDENTIALS}' | awk '{print \$1}'", returnStdout: true).trim()
        AWS_SECRET_ACCESS_KEY = sh(script: "echo '${AWS_CREDENTIALS}' | awk '{print \$2}'", returnStdout: true).trim()
        AWS_DEFAULT_REGION = 'US-EAST-1'
      }
    }
  }
  stages {
    stage ('Configure AWS CLI') {
      steps {
        sh '''
          aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
          aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
          aws configure set region $AWS_DEFAULT_REGION
          aws configure set output json
          '''
      }
    }
    stage('Checkout') {
      steps {
        sh 'echo passed'
        git branch: 'main', url: 'https://github.com/Gbengard/application-assessment-repo.git'
      }
    }
    stage('Build and Test') {
      steps {
        // build the project and create a JAR file
        sh 'mvn mvn install -DskipTests'
      }
    }
    stage('Static Code Analysis') {
      environment {
        SONAR_URL = "3.84.100.98:9000"
      }
      steps {
        withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
          sh 'mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}'
        }
      }
    }
    stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "gbengard/cloudhight:${BUILD_NUMBER}"
        REGISTRY_CREDENTIALS = credentials('docker-cred')
      }
      steps {
        script {
            sh 'docker build -t ${DOCKER_IMAGE} .'
            def dockerImage = docker.image("${DOCKER_IMAGE}")
            docker.withRegistry('https://index.docker.io/v1/', "docker-cred") {
            dockerImage.push()
            }
        }
      }
    }
    stage('Launch Template Userdata') {
        steps {
                sh '''
                    cat > userdata.sh <<EOF
                    #!/bin/bash -xe
                    sudo apt-get update
                    sudo apt-get install docker.io -y
                    sudo su - 
                    usermod -aG docker jenkins
                    usermod -aG docker ubuntu
                    systemctl restart docker
                    EOF
                '''
            }
        }
      stage('Run Container Command and Append In Launch Template') {
        steps {
          sh '''
          echo "docker run -d -p 8080:8080 gbengard:cloudhight:${BUILD_NUMBER}" >> userdata.sh 
          base64_userdata=$(base64 -w 0 /home/gbengard/userdata.sh)
          '''
        }
      }
      stage ('Update the Launch Template and Modify to Latest Version') {
        steps{
          sh '''
          aws ec2 create-launch-template-version \
          --launch-template-name my-template-for-auto-scaling \
          --source-version 1 \
          --version-description ${BUILD_NUMBER} \
          --launch-template-data "{\"UserData\":\"${base64_userdata}\"}"
          aws ec2 modify-launch-template --launch-template-name my-template-for-auto-scaling --default-version ${BUILD_NUMBER}
          '''
        }
      }
    }
  }
