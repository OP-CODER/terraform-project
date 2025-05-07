pipeline {
    agent any
    tools {
        terraform 'terraform'
        ansible 'ansible'
    }
    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/OP-CODER/terraform-project.git'
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Generate Inventory') {
            steps {
                dir('ansible') {
                    sh 'chmod +x generate_inventory.sh'
                    sh './generate_inventory.sh'
                }
            }
        }

        stage('Configure VMs') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key-ubuntu', keyFileVariable: 'UBUNTU_KEY'),
                                 sshUserPrivateKey(credentialsId: 'ssh-key-amazon', keyFileVariable: 'AMAZON_KEY')]) {
                    dir('ansible') {
                        sh '''
                            chmod 600 $UBUNTU_KEY $AMAZON_KEY
                            export ANSIBLE_HOST_KEY_CHECKING=False

                            ansible-playbook -i inventory.ini playbook_backend.yml --private-key=$UBUNTU_KEY -u ubuntu
                            ansible-playbook -i inventory.ini playbook_frontend.yml --private-key=$AMAZON_KEY -u ec2-user
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo '✅ Deployment and configuration complete!'
        }
        failure {
            echo '❌ Something went wrong.'
        }
    }
}
