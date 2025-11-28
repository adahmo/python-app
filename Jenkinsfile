pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "adamumj/adah.py"          // ✅ valid image name
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

        stage('Run Container') {
            steps {
                script {
                    // Run container for testing
                    dockerImage.run('-p 8000:8000')
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
}
