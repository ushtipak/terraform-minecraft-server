#!/bin/bash
#
# Backup previos state of world (if exists), stop minecraft-server and retrieve current saved world

echo "wrapup start"

# expect server ip as an argument
[[ $# != 1 ]] && exit 1

# if previous copy of `world` exists, copy it to `saves` with timestamp
if [[ -d minecraft/world ]]; then
  rollback="saves/$(date +"world-"%F-%H-%M-%S-%N)"
  echo "  rollback [${rollback}]"

  cp -r minecraft/world "${rollback}"
  echo "  copied [!]"
fi

echo "all done \o/"

