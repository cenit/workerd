#!/bin/bash

# Script to automatize the
# FIRST deploy on a "blank" device

# Sense environment
PREF="."

# Init parameters and variables
# shellcheck source=usr/bin/workerd-init
source $PREF"/usr/bin/workerd-init"

# Init ip addresses
if [[ "$1" == "" ]]; then
  echo "Usage : $(basename $0) [all|active|boxid]"
  exit 1
fi
source $PREF"/.ssh/ip.sh" $1

if [[ "$OSTYPE" == "darwin"* ]]; then
  TIMEOUT_APP=gtimeout     # if missing install it with bree install coreutils
else
  TIMEOUT_APP=timeout
fi

for indice in ${!nomi[*]}
do
  nome="${nomi[$indice]}"
  indirizzo="${indirizzi[$indice]}"
  nomeuser=${nomiuser[$indice]}
  passworduser=${passwordsuser[$indice]}

  ### Install SSH keys and setup hostname
  scp -rpd .ssh "${nome}":~
  ssh "${nomeuser}"@"${nome}" chmod 700 .ssh
  ssh "${nomeuser}"@"${nome}" chmod 600 .ssh/authorized_keys
  ssh "${nomeuser}"@"${nome}" chmod 600 .ssh/config
  ssh "${nomeuser}"@"${nome}" chmod 600 .ssh/id_rsa
  ssh "${nomeuser}"@"${nome}" chmod 600 .ssh/id_rsa.pub
  ssh "${nomeuser}"@"${nome}" chmod 600 .ssh/known_hosts
  scp sudoers.sh "$nomeuser"@"${nome}":~
  ssh "${nomeuser}"@"${nome}" chmod 755 sudoers.sh
  ssh "${nomeuser}"@"${nome}" "echo $password | sudo -S ./sudoers.sh $nomeuser"
  ssh "${nomeuser}"@"${nome}" sudo chown "${nomeuser}":"${nomeuser}" /etc/hosts
  ssh "${nomeuser}"@"${nome}" sudo chown "${nomeuser}":"${nomeuser}" /etc/hostname
  scp "hosts/hosts_${nome}"       "$nomeuser"@"${nome}":/etc/hosts
  scp "hosts/hostname_${nome}"    "$nomeuser"@"${nome}":/etc/hostname
  scp "cameras/info/${nome}.info" "$nomeuser"@"${nome}":~
  ssh "${nomeuser}"@"${nome}" chmod 644 "${nome}.info"
  ssh "${nomeuser}"@"${nome}" sudo reboot
  echo "Rebooting..."
  printf "%s" "Waiting for \"${nome}\" ..."
  sleep 10s
  while ! ${TIMEOUT_APP} 2.0 ping -c 1 -n "${indirizzo}" &> /dev/null
  do
      printf "%c" "."
  done
  printf '\n%s\n'  "\"${nome}\" is back online"

  ### Setting static IP on eth0  # broken, removed and done manually
  #echo "Removing NetworkManager..."
  #ssh "${nomeuser}"@"${nome}" sudo systemctl stop NetworkManager.service
  #ssh "${nomeuser}"@"${nome}" sudo systemctl disable NetworkManager.service
  #echo "Setting proper IP address..."
  #ssh "${nomeuser}"@"${nome}" sudo ifconfig eth0 131.154.10.190 netmask 255.255.255.0
  #echo "Setting correct gateway (warning, could take some time)..."
  #ssh "${nomeuser}"@"${nome}" sudo route add default gw 131.154.10.9 eth0
  #echo "Rebooting..."
  #printf "%s" "Waiting for \"${nome}\" ..."
  #sleep 10s
  #while ! ${TIMEOUT_APP} 2.0 ping -c 1 -n "${indirizzo}" &> /dev/null
  #do
  #    printf "%c" "."
  #done
  #printf '\n%s\n'  "\"${nome}\" is back online"

  ### Deploy DDNS  # unnecessary
  #scp -rpd ddclient-3.8.3 "${nome}":~
  #scp install_ddns.sh "${nome}":~
  #ssh "${nomeuser}"@"${nome}" sudo ./install_ddns.sh
  #ssh "${nomeuser}"@"${nome}" rm ./install_ddns.sh

  ### Prerequisites
  #enable journalctl logging
  ssh "${nomeuser}"@"${nome}" sudo mkdir -p /var/log/journal
  ssh "${nomeuser}"@"${nome}" sudo systemd-tmpfiles --create --prefix /var/log/journal
  ssh "${nomeuser}"@"${nome}" sudo systemctl restart systemd-journald
  #install required packages
  scp install_packages_device.sh "$nomeuser"@"${nome}":~
  ssh "${nomeuser}"@"${nome}" chmod 755 install_packages_device.sh
  ssh "${nomeuser}"@"${nome}" sudo ./install_packages_device.sh
  ssh "${nomeuser}"@"${nome}" rm ./install_packages_device.sh

  scp usr/bin/workerd-init "$nomeuser"@"${nome}":~
  ssh "${nomeuser}"@"${nome}" chmod 755 workerd-init
  ssh "${nomeuser}"@"${nome}" sudo mv workerd-init /usr/bin/

  ### Create required folders
  scp setup_folders_and_code.sh "$nomeuser"@"${nome}":~
  ssh "${nomeuser}"@"${nome}" chmod 755 setup_folders_and_code.sh
  ssh "${nomeuser}"@"${nome}" ./setup_folders_and_code.sh
  ssh "${nomeuser}"@"${nome}" rm ./setup_folders_and_code.sh

  ### Install daemons
  scp usr/bin/workerd-bin-deploy  "${nomeuser}"@"${nome}":~
  scp usr/bin/workerd-bin-sync    "${nomeuser}"@"${nome}":~
  scp usr/bin/workerd-conf-deploy "${nomeuser}"@"${nome}":~
  scp usr/bin/workerd-conf-sync   "${nomeuser}"@"${nome}":~
  scp usr/bin/workerd-crond       "${nomeuser}"@"${nome}":~
  scp usr/bin/workerd-data-sync   "${nomeuser}"@"${nome}":~
  scp usr/bin/workerd-errlog-sync "${nomeuser}"@"${nome}":~
  scp usr/bin/workerd-init        "${nomeuser}"@"${nome}":~
  scp usr/bin/workerd-keep-alive  "${nomeuser}"@"${nome}":~
  scp usr/bin/workerd-log-sync    "${nomeuser}"@"${nome}":~
  scp etc/init.d/workerd-starter  "${nomeuser}"@"${nome}":~
  scp move_scripts.sh             "${nomeuser}"@"${nome}":~
  ssh "${nomeuser}"@"${nome}" chmod 755 move_scripts.sh
  ssh "${nomeuser}"@"${nome}" sudo ./move_scripts.sh
  ssh "${nomeuser}"@"${nome}" sudo chown root:root /etc/init.d/workerd-starter
  ssh "${nomeuser}"@"${nome}" sudo systemctl enable workerd-starter.service
  ssh "${nomeuser}"@"${nome}" rm ./move_scripts.sh

  ### Final reboot
  ssh "${nomeuser}"@"${nome}" sudo reboot
  echo "Setup completed, rebooting..."
  printf "%s" "Waiting for \"${nome}\" ..."
  sleep 10s
  while ! ${TIMEOUT_APP} 2.0 ping -c 1 -n "${indirizzo}" &> /dev/null
  do
      printf "%c" "."
  done

  printf '\n%s\n'  "\"${nome}\" is back online"

done
