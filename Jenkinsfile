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

        stage('Run Container for Test') {
            steps {
                script {
                    echo "Starting container for test"
                    // Run container detached (-d) and keep it alive
                    sh "docker run -d --name test_container -p 8000:8000 ${DOCKER_IMAGE}:${env.BUILD_NUMBER}"
            
                    // Optional: wait a few seconds for startup
                    sh "sleep 30"
            
                    // Test the container by curling the exposed port
                    sh "curl -f http://localhost:8000 || (docker logs test_container && exit 1)"
                }
           }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    //Push to dockerhub
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS) {
                        dockerImage.push("${env.BUILD_NUMBER}")
                        dockerImage.push("latest")
                    }
                }
            }
        }
    }
}
