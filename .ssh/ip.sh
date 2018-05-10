#!/bin/bash

declare -a nomi
declare -a indirizzi
declare -a cameraip

IP_DEVICE1="127.0.0.1"
CAMIP_DEVICE1="192.168.1.1"

nomi=(device1 device2)
nomiuser=(user_device1 user_device2)
passwordsuser=(pass_device1 pass_device2)
indirizzi=(${IP_DEVICE1} ${IP_DEVICE2})
cameraip=(${CAMIP_DEVICE1} ${CAMIP_DEVICE2})

case $1 in
  all )
    nomi=(device1 device2)
    nomiuser=(user_device1 user_device2)
    passwordsuser=(pass_device1 pass_device2)
    indirizzi=(${IP_DEVICE1} ${IP_DEVICE2})
    cameraip=(${CAMIP_DEVICE1} ${CAMIP_DEVICE2})
    ;;
  active )
    nomi=(device1 device2)
    nomiuser=(user_device1 user_device2)
    passwordsuser=(pass_device1 pass_device2)
    indirizzi=(${IP_DEVICE1} ${IP_DEVICE2})
    cameraip=(${CAMIP_DEVICE1} ${CAMIP_DEVICE2})
    ;;
  device1 )
    nomi=(device1)
    nomiuser=(user_device1)
    passwordsuser=(pass_device1)
    indirizzi=(${IP_DEVICE1})
    cameraip=(${CAMIP_DEVICE1})
    ;;
  device2 )
    nomi=(device2)
    nomiuser=(user_device2)
    passwordsuser=(pass_device2)
    indirizzi=(${IP_DEVICE2})
    cameraip=(${CAMIP_DEVICE2})
    ;;
  * )
    ;;
esac

export nomi
export nomiuser
export passwordsuser
export indirizzi
export cameraip
