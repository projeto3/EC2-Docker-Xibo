# Projeto Integrdor III
# Aplicação Open Source XIBO

Neste diretório você encontrar os procedimentos para realizar o deploy da apliação de gerenciamento de midia open source XIBO.

-- Procedimentos manuais

**Instalação CMS

mkdir /opt/xibo
cd /opt/xibo

wget https://github.com/xibosignage/xibo-cms/releases/download/1.8.11/xibo-docker.tar.gz
tar --strip 1 -zxvf xibo-docker.tar.gz

*Precisamos criar um arquivo config.env de acordo com o guia de instalação. 
Vamos fazer isso, garantindo que definimos um valor MYSQL_PASSWORD. Isso deve ser apenas alfanumérico. ou seja, 
composto por AZ az 0-9. Sem espaços, pontuação ou outros caracteres especiais. Por exemplo, algo como BTvjCyqQEZ8kGPrb funcionaria. 
Claramente não use essa senha

cp config.env.template config.env

nano config.env

** Salve suas alterações e saia

**Agora vamos subir o CMS

docker-compose up -d

*O CMS será baixado e executado e você poderá fazer o login no endereço IP do seu servidor//

**Configuração do Firewall
Configurará o ufw firewall com as portas certas abertas para HTTP, SSH e XMR:

ufw allow ssh
ufw allow 80/tcp
ufw allow 9505/tcp
ufw enable

**Adicionando Suporte SSL

*Existem várias maneiras de adicionar suporte SSL a essa configuração. O mais simples será instalar 
o Apache no servidor host do Ubuntu e fazer com que ele ative os pedidos SSL no nosso container. Primeiro, 
precisamos parar a execução do CMS, já que precisaremos da porta 80 para o nosso servidor Apache.

cd /opt/xibo

docker-compose down

*Vamos agora mover o Xibo para um número de porta diferente. Estaremos seguindo as instruções no manual 
aqui sob o título "usando portas diferentes": http://xibo.org.uk/manual-tempel/en/install_cms.html//

cp cms_custom-ports.yml.template cms_custom-ports.yml

nano cms_custom-ports.yml

*Edite a seção “ports” dos serviços cms-xmr e cms-web para que eles leiam da seguinte forma:

version: "2.1"
 
services:
    cms-db:
        image: mysql:5.6
        volumes:
            - "./shared/db:/var/lib/mysql"
        restart: always
        environment:
            - MYSQL_DATABASE=cms
            - MYSQL_USER=cms
            - MYSQL_RANDOM_ROOT_PASSWORD=yes
        mem_limit: 1g
        env_file: config.env
    cms-xmr:
        image: xibosignage/xibo-xmr:release-0.7
        ports:
            - "9505:9505"
        restart: always
        mem_limit: 256m
        env_file: config.env
    cms-web:
        image: xibosignage/xibo-cms:release-1.8.9
        volumes:
            - "./shared/cms/custom:/var/www/cms/custom"
            - "./shared/backup:/var/www/backup"
            - "./shared/cms/web/theme/custom:/var/www/cms/web/theme/custom"
            - "./shared/cms/library:/var/www/cms/library"
            - "./shared/cms/web/userscripts:/var/www/cms/web/userscripts"
        restart: always
        links:
            - cms-db:mysql
            - cms-xmr:50001
        environment:
            - XMR_HOST=cms-xmr
        env_file: config.env
        ports:
            - "127.0.0.1:8080:80"
        mem_limit: 1g

Então, especificamente, nós mudamos a linha:

            ports:
                 - "65500:9505"
para

            ports:
                 - "9505:9505"
e

            ports:
                 - "65501:80"
para

            ports:
                 - "127.0.0.1:8080:80"
                 
                 
*Salve suas alterações. Isso garantirá que o XMR seja executado na porta 9505 como antes e 
que o serviço da Web seja executado na porta 8080 apenas na interface de loopback.

Traga os containers de volta com essas mudanças:

docker-compose -f cms_custom-ports.yml up -d   

Agora vamos proteger esse Container com um servidor Apache e um certificado SSL LetsEncrypt:

apt-get install apache2
a2enmod proxy
a2enmod proxy_http

*Agora edite o arquivo de configuração padrão do apache para criar um proxy reverso para o nosso contêiner://

nano /etc/apache2/sites-available/000-default.conf

*Deve conter

<VirtualHost *:80>

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        ProxyPreserveHost On

        ProxyPass / http://127.0.0.1:8080/
        ProxyPassReverse / http://127.0.0.1:8080/

</VirtualHost>

*Salve suas alterações e reinicie o Apache

service apache2 restart

*Nosso CMS agora deve estar disponível na porta 80.
*Se você está usando o ufw, vamos colocar uma regra para o tráfego de https agora//

ufw allow 443/tcp

**Então instale o letsencrypt

add-apt-repository ppa:certbot/certbot
apt-get update
apt-get install python-certbot-apache

*E então gere um certificado.

certbot --apache -d xibo.alexharrington.co.uk

*Se você selecionou a opção para forçar todo o tráfego para HTTPS, a atualização da página da Web 
do CMS o redirecionará automaticamente para a versão HTTPS.

**Atualizando

Quando o 1.8.12 é lançado, a atualização é tão simples quanto:

**Stop the running container

cd /opt/xibo
docker-compose stop

**Backup the existing container data

cd /opt
cp -rp xibo xibo-1.8.9-backup

**Download the new docker-compose files

cd /opt/xibo

wget https://github.com/xibosignage/xibo-cms/releases/download/1.8.10/xibo-docker.tar.gz

tar --strip 1 -zxvf xibo-docker.tar.gz

*Se você não habilitou o SSL, então

docker-compose up -d

*Se você ativou o SSL, será necessário:

cp cms_custom-ports.yml cms_custom-ports.yml.1.8.9

cp cms_custom-ports.yml.template cms_custom-ports.yml

nano cms_custom-ports.yml


*Faça as mesmas edições nesse arquivo, como no guia de instalação acima, para especificar 
as portas corretas a serem usadas e, em seguida, execute.

docker-compose -f cms_custom-ports.yml up -d

**Mudanças no LetsEncrypt

*Se você seguiu este guia anteriormente para ativar o SSL por meio do LetsEncrypt, eles mudaram a maneira 
como os certificados são problemas em resposta a um relatório de segurança recebido em janeiro de 2018.

*Por favor, faça o seguinte para permitir que seus certificados sejam renovados:

add-apt-repository ppa:certbot/certbot
apt-get update
apt-get dist-upgrade
apt-get install python-certbot-apache

*Edite /etc/crontab e remova a linha que você adicionou:

30 2 * * 1 root /usr/bin/letsencrypt renew >> /var/log/le-renew.log

*Execute o certbot para verificar se sua renovação será processada://

certbot renew
