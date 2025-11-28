def dockerImage  // declare globally so it can be reused

pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "adamumj/adahpy"
        DOCKERHUB_CREDENTIALS = "dockerhub"
    }

    stages {
        stage('Pull SCM') {
            steps {
                checkout scm
            }
        }

        stage('Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub',
                                                  usernameVariable: 'USERNAME',
                                                  passwordVariable: 'PASSWORD')]) {
                    sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // build using Dockerfile in repo root
                    dockerImage = docker.build("${DOCKER_IMAGE}:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Run Container for Test') {
            steps {
                script {
                    echo "Starting container for test"
                    sh "docker run -d --name adah-container1 -p 8000:8000 ${DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                    sh "sleep 30"
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

    post {
        always {
            // clean up test container
            sh 'docker rm -f adah-container1 || true'
        }
    }
}

