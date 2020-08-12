# Projeto Integrador III
# Pipeline de entrega continua de infraestrutura na AWS.
Repositório da disciplina projeto integrador III.

O projeto consiste na criação de um pipeline de entrega contínua de infraestrututra na aws baseando-se na metodologia the twelve-factor App (12 fatores).

- Neste repositorio conterá os arquivos e procedimentos necessários para criar um pipeline de entrega continua de uma aplicação e sua infraestrutura utilizando as tecnologias Github, Jenkins, Terraform, Ansible, Shell Script, Docker, Docker-compose e Amazon Web Services.

# Listagem de diretórios e arquivos:
		
	- Ansible - Arquivos e procedimentos para a gestão de configuração do ambiente.
	- Docker - Arquivos e procedimentos para deploy da aplicação com docker e docker-compose.
	- Terraform - Arquivos e procedimentos para deploy da infraestrutura na AWS (infra as code).
  	- Jenkinsfile - Arquivo que contém a definição do pipeline Jenkins.
	- teste.sh - Arquivo em Shell Script reponsável por realizar testes no ambiente e na aplicação.

# Procedimeto para configuração do ambiente
	
	- Instale um servidor jenkins - mais informações sobre a instalação (https://jenkins.io/doc/).
	- Instale o terraform na maquina jenkins - mais informações sobre a instalação (https://www.terraform.io/docs/index.html).
	- Instale o ansible na máquina jenkins - mais informações sobre a instalação (https://www.ansible.com/).
	- Tenha uma conta na AWS - mais informações de como criar uma conta (https://aws.amazon.com/).
	
# Criando ACCESS_KEY na AWS
- Para que o jenkins possa acessar os recursos da AWS é necessária criar um access_key.
Siga o passo a passo da documentação oficial - https://docs.aws.amazon.com/pt_br/IAM/latest/UserGuide/id_credentials_access-keys.html

# Configurando o Jenkins
- Após a instalação do servidor jenkins será necessários fazer alguns ajustes. Para que o jenkins acesse a aws é necessário salvar o access_key, secret_key e region em um arquivo chamado provider.tf.
- Faça acesso ssh a maquina do jenkins e crie o arquivo provider.tf no diretorio /var/lib/jenkins/workspaces/

- Estrutura do arquivo provider.tf

		provider "aws" {
  			access_key = "my_access_key"
  			secret_key = "my_secrte_key"
  			region     = "my_region"
		}

- Configure o ansible para ignorar a verificação de autenticidade do SSH na primeira conexão, vá ate o aqrquivo /etc/ansible/ansible.cfg e edite/adicione a seguinte linha:
		- host_key_checking = False
- Para permitir que o ansible se conecte com as novas instâncias criadas é necessário fazer o upload da chave.pem que será usada para conexão ssh no dirétorio "~/.ssh/chave.pem" do servidor Jenkins, pode ser feito usando o software "Bitvise SSH Client" (https://www.bitvise.com/ssh-client-download) no Windows ou usando o cliente scp no linux com o comando "sudo scp -i jenkins.pem  chave.pem  user@myiphost:~/.ssh/chave.pem".
 
		
- Você pode se deparar com o seguinte erro ao tentar executar sua primeira build no Jenkis "sudo: no tty present and no askpass program specified".
Para resolver isso basta incluir a seguinte linha no arquivo /etc/sudoers do servidor Jenkins:
	- jenkins ALL=(ALL) NOPASSWD: ALL
	
- Instale os seguintes plugins no jenkins
	- Amazon web services sdk
	- Ansible plugin
	- Blue ocean (visualização do pipeline)
	- Git plugin
	- Terraform plugin
	- Ansible	
