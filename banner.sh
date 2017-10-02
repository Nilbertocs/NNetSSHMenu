#!/bin/bash

tput setaf 6 ; echo "O que vc deseja por no banner ?" ; tput sgr0
tput setaf 1
read -p ": " banner
echo "$banner" > /etc/bannerssh
tput sgr0
echo "Banner /etc/bannerssh" >> /etc/ssh/sshd_config
service ssh restart > /dev/null 2> /dev/null
service sshd restart > /dev/null 2> /dev/null
clear
echo "Banner Alterado para:"
tput setaf 1 ; cat /etc/bannerssh ; tput sgr0