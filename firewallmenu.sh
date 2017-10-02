#!/bin/bash

if [ $(id -u) -eq 0 ]
then
	clear
else
	if echo $(id) |grep sudo > /dev/null
	then
	clear
	echo "Voce não é root"
	echo "Seu usuario esta no grupo sudo"
	echo -e "Para virar root execute \033[1;31msudo su\033[0m"
	exit
	else
	clear
	echo -e "Vc nao esta como usuario root, nem com seus direitos (sudo)\nPara virar root execute \033[1;31msu\033[0m e digite sua senha root"
	exit
	fi
fi

clear
tput setaf 1 ; tput smul ; echo "NNET Pack 1.0 © @Nilbertocs" ; tput sgr0
echo -e "
\033[4;36m   Escolha uma opção:  \033[0m
\033[1;34m    Firewall MENU
\033[1;36m[1] Liberar Torrent
\033[1;36m[2] Bloquear Torrent
\033[1;36m[3] Voltar\033[0m"
read -p ": " opcao

case $opcao in
 1)
  /bin/opencomands/torrent;;
 2)
  /bin/opencomands/firewall;;
 3)
  menu;;
 *)
  id > /dev/null 2> /dev/null
esac
