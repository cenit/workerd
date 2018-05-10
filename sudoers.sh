#!/bin/bash

# Remove sudo password prompt

if [ $# -eq 0 ]
then
    echo "No arguments supplied, please relaunch passing the username to enable"
    exit
fi

echo -e "\n$1 ALL=(ALL) NOPASSWD: ALL\n" >> /etc/sudoers

