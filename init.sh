#!/bin/bash
#
# Retrieve minecraft-server package, initialize Terraform

SERVER_VERSION="1.16.4"
SERVER_URL="https://launcher.mojang.com/v1/objects/35139deedbd5182953cf1caa23835da59ca3d7cd/server.jar"


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

echo export DO_PAT="XXXXXXXXXXXXXXXXXXXXXXXXX"
terraform apply                             \
  -var "do_token=${DO_PAT}"                 \
  -var "pub_key=$HOME/.ssh/XXXXXXXXXX.pub"  \
  -var "pvt_key=$HOME/.ssh/XXXXXXXXXX"      \
  -var "ssh_fingerprint=XX:XX:XX:XX:XX:XX:XX"

EOT

