#!/bin/bash

# Script to autogenerate
# ssh-key pairs for
# given targets

declare -a nomi
nomi=(HOST1 HOST2)
nomipub=( "${nomi[@]/%/.pub}" )

for nome in "${nomi[@]}"
do
  ssh-keygen -t rsa -N '' -f "$nome"
done

tar cvf chiavi.tar "${nomi[@]}" "${nomipub[@]}"

for nome in "${nomi[@]}"
do
  rm -f "${nome}"
done

for nomepub in "${nomipub[@]}"
do
  rm -f "${nomepub}"
done
