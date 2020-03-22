#!/bin/bash
#
# Copy world directory to Minecraft server, if `minecraft/world` exists

[[ $# != 1 ]] && exit 1

if [[ -d minecraft/world ]]; then
  /usr/bin/rsync -PHcuva minecraft/world "root@${1}:/opt/minecraft/"
fi

