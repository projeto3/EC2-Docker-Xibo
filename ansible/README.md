# Gestão de configuração das instancias EC2 com ansible

O ansible será utilizado para automatizar as seguintes tarefas:

        - Atualização dos S.O
        - Instalação do docker e docker-compose
        - Configuração do swarm
        - Deploy da aplicação

-  Arquivos

      - hosts: Arquivo de inventário dos hosts
      - play-installDocker.yml: Playbook responsável por instação e configuração do docker e docker-compose
      - play-updateOS.yml: Plabook responsável por atualizar o sistema operacional dos hosts
      - play-deployApp.yml: Playbook reponsável por realizar o deploy da aplicação
