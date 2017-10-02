#!/bin/bash
clear
#MENSAGEM INICIAL	
	tput setaf 7 ; tput setab 1 ; tput bold ; printf '%35s%s%-20s\n' "NNET Pack 2.3 © @Nilbertocs" ; tput sgr0
	echo "● O SCRIPT ESTÁ EM MANUTENÇÃO MUITOS BUGS PODEM OCORRER!"
	echo "● NÃO É RECOMENDADO REALIZAR A INSTALAÇÃO... QUE TAL TENTAR MAIS TARDE?"
	echo "● PARA CANCELAR USE CTRL + C"
#	tput setaf 6 ; tput bold ; echo "" ; echo "Este script irá:" ; echo ""
#	echo "● Instalar e configurar o proxy squid nas portas 80, 3128, 8080 e 8799"
#	echo "● Configurar o OpenSSH para rodar nas portas 22 e 443"
#	echo "● Instalar e Configurar o OpenVPN"
#	echo "● Instalar um conjunto de scripts como comandos do sistema para o gerenciamento" ; tput sgr0
#	echo ""
#CONFIGURAÇÃO INICIAL
	tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
	IP=$(wget -qO- ipv4.icanhazip.com)
	tput setaf 3 ; tput bold ; read -p "Confirme o IP deste servidor: " -e -i $IP ipdovps tput sgr0
	if [ -z "$ipdovps" ]
	then
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "" ; echo " Você não digitou o IP deste servidor. Tente novamente. " ; echo "" ; echo "" ; tput sgr0
	exit 1
	fi
	clear
	#SSHUses
		if [ -f "/root/usuarios.db" ]
		then
		tput setaf 6 ; tput bold ;	echo ""
		echo "Uma base de dados de usuários SSH foi encontrada!"
		tput setaf 6 ; tput bold ;	echo ""
		echo "[1] Manter Base de Dados Atual"
		echo "[2] Criar uma Nova Base de Dados"
		echo "" ; tput sgr0
		read -p "Opção?: " -e -i 1 optiondb
		else
		awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /root/usuarios.db
		fi
		clear
	#OVPNUsers
		if [ -f "/root/openclientes.db" ]
		then
		tput setaf 6 ; tput bold ;	echo ""
		echo "Uma base de dados de usuários OpenVPN foi encontrada!"
		tput setaf 6 ; tput bold ;	echo ""
		echo "[1] Manter Base de Dados Atual"
		echo "[2] Criar uma Nova Base de Dados"
		echo "" ; tput sgr0
		read -p "Opção?: " -e -i 1 optiondb
		else
		awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /root/openclientes.db
		fi
	#Compressão SSH	
		echo ""
		tput setaf 3 ; tput bold ; read -p "Ativar a compressão SSH (pode aumentar o consumo de RAM)? [s/n]) " -e -i n sshcompression tput sgr0
		echo ""
		clear
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "Aguarde, Estamos atualizando seu sistema e instalando pacotes..." ; echo "" ; tput sgr0
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "Isso pode demorar um pouco, que tal um café?" ; echo "" ; tput sgr0
	sleep 3
	tput setaf 6
#ATUALIZANDO O SISTEMA E INSTALANDO DEPENDENCIAS
	apt-get update 1>/dev/null 2>/dev/null
	apt-get upgrade 1>/dev/null 2>/dev/null
	apt-get install squid3 bc screen nano unzip git dos2unix wget htop nload python-pip 1>/dev/null 2>/dev/null
	pip install speedtest-cli
	killall apache2
	apt-get purge apache2 1>/dev/null 2>/dev/null
	if [ -f "/usr/sbin/ufw" ] ; then
	ufw allow 443/tcp ; ufw allow 80/tcp ; ufw allow 3128/tcp ; ufw allow 8799/tcp ; ufw allow 8080/tcp
	fi
	if [ -d "/etc/squid3/" ] ; then
	wget http://follem.cloud/s/vpsmanagement/squid1.text -O /tmp/sqd1
	echo "acl url3 dstdomain -i $ipdovps" > /tmp/sqd2
	wget http://follem.cloud/s/vpsmanagement/squid2.text -O /tmp/sqd3
	cat /tmp/sqd1 /tmp/sqd2 /tmp/sqd3 > /etc/squid3/squid.conf
	wget http://follem.cloud/s/vpsmanagement/payload.text -O /etc/squid3/payload.txt
	echo " " >> /etc/squid3/payload.txt
	grep -v "^Port 443" /etc/ssh/sshd_config > /tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config
	echo "Port 443" >> /etc/ssh/sshd_config
	echo "Banner /etc/banner" >> /etc/ssh/shhd_config
	grep -v "^PasswordAuthentication yes" /etc/ssh/sshd_config > /tmp/passlogin && mv /tmp/passlogin /etc/ssh/sshd_config
	echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
#INSTALAÇÃO DE CONTROLES SSH
	wget http://follem.cloud/s/vpsmanagement/addhost.sh -O /bin/addhost
	chmod +x /bin/addhost
	wget http://follem.cloud/s/vpsmanagement/alterarsenha.sh -O /bin/alterarsenha
	chmod +x /bin/alterarsenha
	wget http://follem.cloud/s/vpsmanagement/banner.sh -O /bin/banner
	chmod +x /bin/banner
	wget http://follem.cloud/s/vpsmanagement/criarusuario.sh -O /bin/criarusuario
	chmod +x /bin/criarusuario
	wget http://follem.cloud/s/vpsmanagement/delhost.sh -O /bin/delhost
	chmod +x /bin/delhost
	wget http://follem.cloud/s/vpsmanagement/expcleaner.sh -O /bin/expcleaner
	chmod +x /bin/expcleaner
	wget http://follem.cloud/s/vpsmanagement/mudardata.sh -O /bin/mudardata
	chmod +x /bin/mudardata
	wget http://follem.cloud/s/vpsmanagement/remover.sh -O /bin/remover
	chmod +x /bin/remover
	wget http://follem.cloud/s/vpsmanagement/sshlimiter.sh -O /bin/sshlimiter
	chmod +x /bin/sshlimiter
	wget http://follem.cloud/s/vpsmanagement/alterarlimite.sh -O /bin/alterarlimite
	chmod +x /bin/alterarlimite
	wget http://follem.cloud/s/vpsmanagement/sshmonitor.sh -O /bin/sshmonitor
	chmod +x /bin/sshmonitor
	wget http://follem.cloud/s/vpsmanagement/OpenUdp.sh -O /bin/udp_unlock
	chmod +x /bin/udp_unlock
	wget http://follem.cloud/s/vpsmanagement/tcptweaker.sh -O /bin/tcptweaker
	chmod +x /bin/tcptweaker
	wget http://follem.cloud/s/vpsmanagement/hostmenu.sh -O /bin/hostmenu
	chmod +x /bin/hostmenu
	wget http://follem.cloud/s/vpsmanagement/usersmodmenu.sh -O /bin/usersmodmenu
	chmod +x /bin/usersmodmenu
	wget http://follem.cloud/s/vpsmanagement/firewallmenu.sh -O /bin/firewallmenu
	chmod +x /bin/firewallmenu
	wget http://follem.cloud/s/vpsmanagement/menu.sh -O /bin/menu
	chmod +x /bin/menu
	wget http://follem.cloud/s/vpsmanagement/netflix.sh -O /bin/nfx
	chmod +x /bin/nfx
#INSTALAÇÃO DO OPENVPN
	wget http://follem.cloud/s/vpsmanagement/configvps.sh -O /bin/configvps
	chmod +x /bin/configvps
	wget http://follem.cloud/s/vpsmanagement/OpenVPN.sh -O /bin/OpenVPN
	chmod +x /bin/OpenVPN
#CONFIGURANDO SQUID E OPENSSH

		if [ ! -f "/etc/init.d/squid3" ]
		then
			service squid3 reload > /dev/null
		else
			/etc/init.d/squid3 reload > /dev/null
		fi
		if [ ! -f "/etc/init.d/ssh" ]
		then
			service ssh reload > /dev/null
		else
			/etc/init.d/ssh reload > /dev/null
		fi
		fi
		if [ -d "/etc/squid/" ]
		then
		wget http://follem.cloud/s/vpsmanagement/squid1.text -O /tmp/sqd1
		echo "acl url3 dstdomain -i $ipdovps" > /tmp/sqd2
		wget http://follem.cloud/s/vpsmanagement/squid.text -O /tmp/sqd3
		cat /tmp/sqd1 /tmp/sqd2 /tmp/sqd3 > /etc/squid/squid.conf
		wget http://follem.cloud/s/vpsmanagement/payload.text -O /etc/squid/payload.txt
		echo " " >> /etc/squid/payload.txt
		grep -v "^Port 443" /etc/ssh/sshd_config > /tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config
		echo "Port 443" >> /etc/ssh/sshd_config
		grep -v "^PasswordAuthentication yes" /etc/ssh/sshd_config > /tmp/passlogin && mv /tmp/passlogin /etc/ssh/sshd_config
		echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
#FINALIZANDO E REINICIANDO SERVIÇOS
	if [ ! -f "/etc/init.d/squid" ]
	then
		service squid reload > /dev/null
	else
		/etc/init.d/squid reload > /dev/null
	fi
	if [ ! -f "/etc/init.d/ssh" ]
	then
		service ssh reload > /dev/null
	else
		/etc/init.d/ssh reload > /dev/null
	fi
	fi
#	clear
#FINALIZANDO CONFIGURAÇÃO SSH
	if [[ "$optiondb" = '2' ]]; then
		awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /root/usuarios.db
	fi
	if [[ "$sshcompression" = 's' ]]; then
		grep -v "^Compression yes" /etc/ssh/sshd_config > /tmp/sshcp && mv /tmp/sshcp /etc/ssh/sshd_config
		echo "Compression yes" >> /etc/ssh/sshd_config
	fi
	if [[ "$sshcompression" = 'n' ]]; then
		grep -v "^Compression yes" /etc/ssh/sshd_config > /tmp/sshcp && mv /tmp/sshcp /etc/ssh/sshd_config
	fi
	rm /root/NNetPack.sh
	rm /home/NNetPack.sh
#	clear
#MENSAGEM DE CONFIRMAÇÃO
	echo ""
	tput setaf 2 ; tput setab 1 ; tput bold ; echo "                          Tudo Pronto!!!                         " ; tput sgr0
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "Proxy Squid Instalado e rodando nas portas: 80, 3128, 8080 e 8799" ; tput sgr0
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "OpenSSH rodando nas portas 22 e 443                              " ; tput sgr0
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "Canal do telegram, para saber de atualizações @NilbertoNNet      " ; tput sgr0
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "Para iniciar use o comando: menu                                 " ; tput sgr0
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "                                                                 " ; tput sgr0
sleep 3
dos2unix /bin/menu
menu