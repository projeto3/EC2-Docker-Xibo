#!/bin/bash

#Salva o endereço dns publico da instância
aws_dns=$(cat terraform/aws_dns.txt)
echo "$aws_dns"

SERVICE_PORT=80

echo "Realizando teste de conectividade..."
ping -qc5 $aws_dns

#Verifica se a instancia AWS está UP
echo

if ! ping -qc2 $aws_dns > /dev/null; then
	echo -e "$aws_dns: Status da instancia EC2 -> \033[0;31mOFFLINE\033[0m"
	echo "O teste de conectividade falhou, verifique sua instancia!"
	exit
else 
	echo -e "$aws_dns: Status da instancia EC2 -> \033[0;32mONLINE\033[0m"
fi

echo "Realizando teste de requisição (HTTP GET)"
sleep 1
#Envia uma requisição HTTP GET para o APP

STATUS_CODE=$(curl --write-out %{http_code} --silent --output /dev/null $aws_dns:$SERVICE_PORT)

#Verifica se a resposta do HTTP GET é igual a 200, caso verdadeiro a requisiço foi um sucesso.
if [ $STATUS_CODE -eq 302 ]; then
	echo -e "Teste de requisição....\033[0;32mOK\033[0m :: $(date +%F\ %T)"
	echo "URL da aplicação http://$aws_dns:$SERVICE_PORT"
else
	echo -e "Teste de requisição... \033[0;31mFAIL\033[0m :: $(date +%F\ %T)"
	echo "Teste de requisição falhou, verifique o log de deploy da aplicação!"
fi
