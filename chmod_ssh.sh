#!/bin/bash

# Scripts to chmod the ssh files

# Sense environment
PREF=

# Init parameters and variables
# shellcheck source=usr/bin/workerd-init
source $PREF"/usr/bin/workerd-init"

chmod 700 .ssh
chmod 600 .ssh/authorized_keys
chmod 600 .ssh/config
chmod 600 .ssh/id_rsa
chmod 600 .ssh/id_rsa
chmod 700 .ssh/ip.sh
chmod 600 .ssh/known_hosts
