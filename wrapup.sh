#!/bin/bash
#
# Backup previos state of world (if exists), stop minecraft-server and retrieve current saved world

echo "wrapup start"

# if previous copy of `world` exists, copy it to `saves` with timestamp
if [[ -d minecraft/world ]]; then
  rollback="saves/$(date +"world-"%F-%H-%M-%S-%N)"
  echo "  rollback [${rollback}]"

  cp -r minecraft/world "${rollback}"
  echo "  copied [!]"
fi

# retrieve server ip from `terraform.tfstate`
state="terraform.tfstate"
if [[ ! -f "${state}" ]]; then
  echo "missing state [${state}]; exiting ..."
  exit 1
fi
output=$(cat ${state} | grep value)
if [[ x${output} == "x" ]]; then
  echo "unable to get ip; exiting ..."
  exit 1
fi
ip=$(echo "${output}" | awk '{print $2}' | tr -d '",')
if [[ x${ip} == "x" ]]; then
  echo "unable to parse ip; exiting ..."
  exit 1
fi


echo "all done \o/"

