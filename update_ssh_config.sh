#!/bin/bash

# Scripts to update the ssh files
# on selected remote device

if [[ $1 == "" ]]; then
  echo "Usage : $0 [boxid|all|active]"
  exit 1
fi

# Sense environment
PREF="."

# Init parameters and variables
# shellcheck source=usr/bin/workerd-init
source $PREF"/usr/bin/workerd-init"

# Load device names and addresses
source ".ssh/ip.sh" $1

for indice in ${!nomi[*]}
do
  nome=${nomi[$indice]}
  nomeuser=${nomiuser[$indice]}

  echo "*** $((indice+1))/${#nomi[@]}) Deploying ssh config for $nomeuser @ $nome"

  scp chmod_ssh.sh         "$nomeuser"@"${nome}":~
  scp .ssh/authorized_keys "$nomeuser"@"${nome}":~/.ssh/
  scp .ssh/config          "$nomeuser"@"${nome}":~/.ssh/
  scp .ssh/id_rsa          "$nomeuser"@"${nome}":~/.ssh/
  scp .ssh/id_rsa.pub      "$nomeuser"@"${nome}":~/.ssh/
  scp .ssh/ip.sh           "$nomeuser"@"${nome}":~/.ssh/
  scp .ssh/known_hosts     "$nomeuser"@"${nome}":~/.ssh/

  val="ssh \"$nomeuser\"@\"$nome\" chmod 755 chmod_ssh.sh"; echo "$val"; eval "$val"
  val="ssh \"$nomeuser\"@\"$nome\" ./chmod_ssh.sh";         echo "$val"; eval "$val"

done
