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

        stage('Login') {
            steps {
               // Example: Docker login using Jenkins credentials
               withCredentials([usernamePassword(credentialsId: 'dockerhub',
                                                 usernameVariable: 'DOCKER_USER',
                                                 passwordVariable: 'DOCKER_PASS')]) {
               sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS'
               }
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
                    sh "docker run -d --name adah-container1 -p 8000:8000 ${DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                    sh "sleep 60"
                    sh "curl -f http://localhost:8000 || (docker logs adah-container1 && exit 1)"
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
