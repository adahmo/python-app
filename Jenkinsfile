pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "adamumj/adahpy"          // ✅ avoid '.' in image name
        DOCKERHUB_CREDENTIALS = "dockerhub"      // Jenkins credentials ID
    }

    stages {
        stage('Pull SCM') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Run Container for Test') {
            steps {
                script {
                    echo "Starting container for test"
                    sh "docker run -d --name adah-container1 -p 8005:8005 ${DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                    sh "sleep 30"
                    sh "curl -f http://localhost:8005 || (docker logs adah-container1 && exit 1)"
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        dockerImage.push("${env.BUILD_NUMBER}")
                        dockerImage.push("latest")
                    }
                }
            }
        }
    }

    //post {
        //always {
            //echo "Cleaning up container"
            //sh "docker rm -f adah-container1 || true"
        //}
    //}
}
