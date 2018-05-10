#!/bin/bash

# Scripts to update the
# workerd-crond dependency scripts
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

  echo "*** $((indice+1))/${#nomi[@]}) Deploying daemons for $nomeuser @ $nome"

  val="ssh \"$nomeuser\"@\"$nome\" sudo systemctl stop workerd-starter.service";      echo "$val"; eval "$val"
  val="ssh \"$nomeuser\"@\"$nome\" sudo systemctl reset-failed";                      echo "$val"; eval "$val"
  scp usr/bin/workerd-bin-deploy  "$nomeuser"@"$nome":~
  scp usr/bin/workerd-bin-sync    "$nomeuser"@"$nome":~
  scp usr/bin/workerd-conf-deploy "$nomeuser"@"$nome":~
  scp usr/bin/workerd-conf-sync   "$nomeuser"@"$nome":~
  scp usr/bin/workerd-crond       "$nomeuser"@"$nome":~
  scp usr/bin/workerd-data-sync   "$nomeuser"@"$nome":~
  scp usr/bin/workerd-errlog-sync "$nomeuser"@"$nome":~
  scp usr/bin/workerd-init        "$nomeuser"@"$nome":~
  scp usr/bin/workerd-keep-alive  "$nomeuser"@"$nome":~
  scp usr/bin/workerd-log-sync    "$nomeuser"@"$nome":~
  scp etc/init.d/workerd-starter  "$nomeuser"@"$nome":~

  scp move_scripts.sh "$nomeuser"@"$nome":~
  val="ssh \"$nomeuser\"@\"$nome\" chmod 755 move_scripts.sh";                         echo "$val"; eval "$val"
  val="ssh \"$nomeuser\"@\"$nome\" sudo ./move_scripts.sh";                            echo "$val"; eval "$val"
  val="ssh \"$nomeuser\"@\"$nome\" sudo chown root:root /etc/init.d/workerd-starter";  echo "$val"; eval "$val"
  val="ssh \"$nomeuser\"@\"$nome\" sudo systemctl daemon-reload";                      echo "$val"; eval "$val"
  val="ssh \"$nomeuser\"@\"$nome\" sudo systemctl start workerd-starter.service";      echo "$val"; eval "$val"
  val="ssh \"$nomeuser\"@\"$nome\" rm ./move_scripts.sh";                              echo "$val"; eval "$val"
done
