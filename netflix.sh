#!/bin/bash
#Configura NETFLIX Experimental
tput setaf 1 ; tput smul ; echo "NNET Pack 2.3 © @Nilbertocs" ; tput sgr0

echo "nameserver 4.2.2.3" > /etc/resolv.conf ; echo "nameserver 4.2.2.4" >> /etc/resolv.conf

apt-get update && apt-get -y install vim dnsutils curl sudo git && curl -sSL https://get.docker.com/ | sh && git clone https://github.com/Nilbertocs/netflix-proxy /opt/netflix-proxy && cd /opt/netflix-proxy && ./build.sh


