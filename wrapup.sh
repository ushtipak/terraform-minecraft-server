#!/bin/bash
#
# Backup previos state of world (if exists), stop minecraft-server and retrieve current saved world

echo "wrapup start"

# if previous copy of `world` exists, copy it to `saves` with timestamp
if [[ -d minecraft/world ]]; then
  rollback="saves/$(date +"world-"%F-%H-%M-%S-%N)"
  echo "  rollback [${rollback}]"

  mv minecraft/world "${rollback}"
  echo "  archived [!]"
fi

# retrieve server ip from `terraform.tfstate`
state="terraform.tfstate"
if [[ ! -f "${state}" ]]; then
  echo "missing state [${state}]; exiting ..."
  exit 1
fi
output=$(grep value < "${state}")
if [[ x${output} == "x" ]]; then
  echo "unable to get ip; exiting ..."
  exit 1
fi
ip=$(echo "${output}" | awk '{print $2}' | tr -d '",')
if [[ x${ip} == "x" ]]; then
  echo "unable to parse ip; exiting ..."
  exit 1
fi
echo "  ip [${ip}]"

# invoke server stop and retrive saved world
ssh "root@${ip}" "systemctl stop minecraft.service"
/usr/bin/rsync -PHcuva "root@${ip}:/opt/minecraft/world" minecraft

echo "all done \o/"

