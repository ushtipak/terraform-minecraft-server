#!/bin/bash
#
# Retrieve minecraft-server package, initialize Terraform

SERVER_VERSION="1.15.2"
SERVER_URL="https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar"


# fetch server (www.minecraft.net/en-us/download/server/)
echo "> retrieve server [${SERVER_VERSION}]"
wget -q "${SERVER_URL}" -O "minecraft/server.jar"

# retrieve digitalocean terraform provider
echo "> initialize terraform"
terraform init

# create `saves` to archive worlds
mkdir saves

cat << 'EOT'

> usage

echo export DO_PAT="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
terraform apply                            \
  -var "do_token=${DO_PAT}"                \
  -var "pub_key=$HOME/.ssh/XXXXXXXXXX.pub" \
  -var "pvt_key=$HOME/.ssh/XXXXXXXXXX"     \
  -var "ssh_fingerprint=XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX"

EOT

