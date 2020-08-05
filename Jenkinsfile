//Declarative Pipeline

pipeline {
    agent any
    stages {
                    stage('Codigo') {
                        steps {
                             parallel(
                                   Informacoes_da_build: {
                                           sh 'echo "BUILD_DISPLAY_NAME" :: $BUILD_DISPLAY_NAME'
                                           sh 'echo "NODE_LABELS" :: $NODE_LABELS'
                                           sh 'echo "GIT_COMMIT" :: $GIT_COMMIT'
                                           sh 'echo "BUILD_TAG" :: $BUILD_TAG'
                                           sh 'echo "GIT_BRANCH" :: $GIT_BRANCH'
                                           sh 'echo "GIT_AUTHOR_NAME" :: $GIT_AUTHOR_NAME'
                                    },
                                    
                                    Copiando_git:{
                       
                                     git url: 'https://github.com/projeto3/EC2-Docker-Xibo.git'

                                            }
                                   
                                     )
                        }
                    }

         stage('Config') {

            steps {
                  parallel(
                             Configurando_Infra: {
                                   dir('terraform/') {
                                   sh 'cp /var/lib/jenkins/workspace/prov.tf .'
                                   sh "sudo terraform init"
                                   sh "sudo terraform plan"
                                   }   
                                 },
                                Configurando_Aplicacao: {
                                         
                                          echo 'Config APP....'

                                                        }
                                 )
                }
            }
        
        
        stage('Criando Instancia') {
                        steps {
                    dir('terraform/') {
                        sh "sudo terraform apply -auto-approve"
                        sh 'terraform output aws_dns > aws_dns.txt'
                        sh 'terraform output aws_dns > hosts'
                                             
                    }
                    echo 'Criando Instancia...'
            }
        
        }
                      
    stage('Config ambiente') {

            steps {
                dir('ansible/'){
                    sh 'sudo cp ../terraform/hosts .'
                    sh 'echo "Aguardando serviço ssh iniciar..."'
                    sh 'sleep 60'
                    sh 'sudo ansible-playbook play-updateOS.yml -i hosts --private-key "/home/ubuntu/.ssh/teste-jenkins.pem" -s -u ec2-user'
                    sh 'sudo ansible-playbook play-installDocker.yml -i hosts --private-key "/home/ubuntu/.ssh/teste-jenkins.pem" -s -u ec2-user'
                    
                }
                echo 'Config....'
            }
        }
        
    stage('Deploy') {

            steps {
                dir('ansible/'){
                     //sh 'sudo ansible-playbook play-configApp.yml -i hosts --private-key "/home/ubuntu/.ssh/testejk.pem" -s -u ec2-user'
                     //sh 'sudo ansible-playbook play-deployApp.yml -i hosts --private-key "/home/ubuntu/.ssh/testejk.pem" -s -u ec2-user'
                     sh 'sudo ansible-playbook play-configWord.yml -i hosts --private-key "/home/ubuntu/.ssh/teste-jenkins.pem" -s -u ec2-user'
                     sh 'sudo ansible-playbook play-deployWord.yml -i hosts --private-key "/home/ubuntu/.ssh/teste-jenkins.pem" -s -u ec2-user'
                }
                echo 'Deploying....'
            }
        }
        
         stage('Test') {

            steps {
                 sh 'sudo chmod +x teste.sh'
                 sh 'sleep 30'
                 sh './teste.sh'
                 echo 'Testing..'
             }
         }
        
         stage('Testes OK?') {

            steps {
                    script {
                        // capture the approval details in approvalMap.
                        approvalMap = input id: 'test', message: 'Aplicação Buildada com Sucesso', ok: 'Processar',
                        parameters: [choice(choices: 'Sim,Testes Realizados pode destruir\nAplicar em Procução', description: 'Select Ambiente', name: 'Build'), string(defaultValue: '', description: '', name: 'Descrição')],  submitterParameter: 'APPROVER'
                    
                }

            }
         }
             stage('Aplica em Produção') {
                    when {
                         expression { params.approvalMap == 'Aplicar em Procução' }
                    }
                     steps {
                        
                    echo 'I only execute on the Prod branch'
               }
                
            }
       
        stage('Destroy') {

            steps {
                dir('terraform/') {
                sh "sudo terraform destroy -force"
                }
                echo 'Apagando repo....'
            }

        }

}
}
