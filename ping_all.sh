#!/bin/bash

# Scripts to ping at
# once all remote devices

# Sense environment
PREF="."

# Init parameters and variables
# shellcheck source=usr/bin/workerd-init
source $PREF"/usr/bin/workerd-init"

# Init ip addresses
# shellcheck source=.ssh/ip.sh
source $PREF"/.ssh/ip.sh" $1

if [[ "$OSTYPE" == "darwin"* ]]; then
  TIMEOUT_APP=gtimeout     # if missing install it with brew install coreutils
else
  TIMEOUT_APP=timeout
fi

for indice in ${!nomi[*]}
do
  nome=${nomi[$indice]}
  indirizzo=${indirizzi[$indice]}

  printf "%s" "Waiting for \"${nome}\" ..."
#  while ! ${TIMEOUT_APP} 2.0 ping -c 1 -n "${indirizzo}" &> /dev/null
#  do
#      printf "%c" "."
#  done
  ssh -q $nome exit &> /dev/null
  sshval=$?
  [ $sshval == 0 ]   && printf "%s\n" " \"${nome}\" is ready for SSH!"
  [ $sshval == 255 ] && printf "%s\n" " \"${nome}\" UNREACHABLE by SSH"
done
