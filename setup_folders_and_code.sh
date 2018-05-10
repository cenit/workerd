#!/bin/bash

# Inner script (usually not launched manually)
# to setup the correct folder tree and
# first_deploy apps on remote devices

# Sense environment
PREF=""

# Init parameters and variables
# shellcheck source=usr/bin/workerd-init
source $PREF"/usr/bin/workerd-init"

mkdir -p ${CODE}
cd ${CODE}

git clone --recurse-submodules https://github.com/cenit/${REPO}
cd ${REPO}

echo "mkdir -p ${JSON_SYNC_PATH}"
mkdir -p ${JSON_SYNC_PATH}
echo "mkdir -p ${CSV_SYNC_PATH}"
mkdir -p ${CSV_SYNC_PATH}
echo "mkdir -p ${BIN_SYNC_PATH}"
mkdir -p ${BIN_SYNC_PATH}
echo "mkdir -p ${CONF_SYNC_PATH}"
mkdir -p ${CONF_SYNC_PATH}
echo "mkdir -p ${CONF_DEPL_PATH}"
mkdir -p ${CONF_DEPL_PATH}
echo "mkdir -p ${LOG_PATH}"
mkdir -p ${LOG_PATH}
echo "mkdir -p ${SCRATCH_PATH}"
mkdir -p ${SCRATCH_PATH}
