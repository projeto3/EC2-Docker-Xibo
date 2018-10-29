#!/bin/bash

DIR="/opt/xibo/"

mkdir $DIR

cd $DIR

wget https://github.com/xibosignage/xibo-cms/releases/download/1.8.11/xibo-docker.tar.gz

tar --strip 1 -zxvf xibo-docker.tar.gz

cp config.env.template config.env

sed -i '/MYSQL_PASSWORD/ s/MYSQL_PASSWORD=/MYSQL_PASSWORD=mypassword/g' config.env
