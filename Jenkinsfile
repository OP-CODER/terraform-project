pipeline {
    agent any
    tools {
        terraform 'Terraform'  // Ensure this matches the name you provided in the tool configuration
        ansible 'Ansible'      // Ensure this matches the name you provided in the tool configuration
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
                    sh '''
                        export AWS_ACCESS_KEY_ID=AKIAQZHMQCF6NLNRQ7PY
                        export AWS_SECRET_ACCESS_KEY=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
                        export AWS_DEFAULT_REGION=us-east-1
                        terraform init
                        terraform apply -auto-approve
                    '''
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
                withCredentials([sshUserPrivateKey(credentialsId: 'ubuntu1', keyFileVariable: 'UBUNTU_KEY'),
                                 sshUserPrivateKey(credentialsId: 'ec2-user1', keyFileVariable: 'AMAZON_KEY')]) {
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
