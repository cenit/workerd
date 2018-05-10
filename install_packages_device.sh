#!/bin/bash

# Inner script (usually not launched manually)
# to setup the correct packages on (remote) devices

if [ ! "$(whoami)" == "root" ]
then
  echo "Please run as root"
  exit
fi

apt-get update
add-apt-repository -y universe
add-apt-repository -y multiverse
apt-get update
apt-get -f install -y
apt-get install -y apache2 apache2-utils screen nano vim
