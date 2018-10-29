#!/bin/bash

#Libera acesso root
sed -i '/disable_root: true/ s/true/false/g' /etc/cloud/cloud.cfg
sed -i '/ssh_pwauth:   false/ s/false/true/g' /etc/cloud/cloud.cfg
sed -i '/PasswordAuthentication no/ s/no/yes/g' /etc/ssh/sshd_config
sed -i '/PermitRootLogin no/ s/no/yes/g' /etc/ssh/sshd_config

#Descomenta a linha
sed -i '/disable_root:/ s/^#//' /etc/cloud/cloud.cfg
sed -i '/ssh_pwauth:/ s/^#//' /etc/cloud/cloud.cfg
sed -i '/PasswordAuthentication/ s/^#//' /etc/ssh/sshd_config
sed -i '/PermitRootLogin/ s/^#//' /etc/ssh/sshd_config

#Usuario de Serviço
usermod --password PASSWORD root


sudo adduser ansible
usermod --password PASSWORD ansible



sudo service sshd restart

