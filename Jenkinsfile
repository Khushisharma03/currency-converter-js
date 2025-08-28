pipeline {
    agent any

    environment {
        EC2_USER   = 'ec2-user'
        EC2_IP     = '13.220.54.58'
        IMAGE_NAME = 'currency-converter'
    }

    stages {
        stage('Clone Repo') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Save Image as tar') {
            steps {
                sh 'docker save $IMAGE_NAME > image.tar'
            }
        }

        stage('Copy Image to EC2') {
            steps {
                sshagent(['ec2-key']) {
                    sh '''
                        scp -o StrictHostKeyChecking=no image.tar $EC2_USER@$EC2_IP:/home/ec2-user/
                    '''
                }
            }
        }

        stage('Deploy on EC2') {
            steps {
                sshagent(['ec2-key']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_IP << EOF
                            docker load < image.tar
                            docker stop currency-converter || true
                            docker rm currency-converter || true
                            docker run -d -p 80:80 --name currency-converter currency-converter
                        EOF
                    '''
                }
            }
        }
    }
}


