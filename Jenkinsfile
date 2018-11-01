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
                       // sh "sudo terraform apply -auto-approve"
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
                                   sh 'cp /var/lib/jenkins/workspace/provider.tf .'
                                   sh "terraform init"
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
                        
                    }
                    echo 'Criando Instancia...'
            }
        
        }
                      
    stage('Config ambiente') {

            steps {
                //dir('ansible/'){
                //    sh "cat aws_dns.txt > hosts"
                  //  sh "ansible-playbook -i hosts -f play-updateOS.yml"
                    //sh "ansible-playbook -i hosts -f play-installDocker.yml"
                //}
                echo 'Config....'
            }
        }
        
    stage('Deploy') {

            steps {
                //dir('ansible/'){
                    //sh "ansible-playbook -i hosts -f play-deployApp.yml"
                //}
                echo 'Deploying....'
            }
        }
        
         stage('Test') {

            steps {
                 sh 'sudo chmod +x teste.sh'
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
                echo 'apagando repo....'
            }

        }

}
}
