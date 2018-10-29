#!/bin/bash

#Libera acesso root
sed -i '/disable_root: true/ s/true/false/g' /etc/cloud/cloud.cfg
sed -i '/ssh_pwauth: false/ s/false/true/g' /etc/cloud/cloud.cfg

sed -i '/PasswordAuthentication no/ s/no/yes/g' /etc/ssh/sshd_config
sed -i '/PermitRootLogin no/ s/no/yes/g' /etc/ssh/sshd_config
sudo service sshd restart

