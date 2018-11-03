# Gestão de configuração das instancias EC2 com ansible

O ansible será utilizado para automatizar as seguintes tarefas:

        - Atualização dos S.O
        - Instalação do docker e docker-compose
        - Configuração da aplicação
        - Deploy da aplicação


-  Arquivos

      - hosts: Arquivo de inventário dos hosts
      - deploy.sh: Arquivo responsável por automatizar as configurações necessárias para a aplicação open source Xibo.
      - play-updateOS.yml: Plabook responsável por automatizar a atualização do sistema operacional dos hosts.
      - play-installDocker.yml: Playbook responsável por automatizar a instalação e configuração do docker e docker-compose.
      - play-configApp.yml: Playbook responsável automatizar as configurações necessarias para a aplicação.
      - play-deployApp.yml: Playbook reponsável por automatizar o deploy da aplicação.
