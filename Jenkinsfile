pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "adamumj/adah.py"
        DOCKERHUB_CREDENTIALS = "dockerhub"

    }
    stages {
        stage('Adah-Build Docker Image'){
            steps{
                script {
                    dockerImage = docker.build("${DOCKER_IMAGE}:$env.BUILD_NUMMBER")
                }

            }

        }
    }
        stage('Adah-Login to Dockerhub'){
            steps{
                script {
                    docker.withRegistry('', DOCKERHUB_CREDENTIALS)
                }
                
            }
        stage ('Docker Run'){
            steps {
                script {
                    //Run container
                    dockerImage.run('-p 8000:8000')
                }
            }
        }    

        }
        stage('Adah-Push to Dockerhub'){
            steps{
                script {
                    //Pushing to dockerhub
                    dockerImage.push("$env.BUILD_NUMBER}")
                    dockerImage.push('latest')
                }

            }
        }
}

