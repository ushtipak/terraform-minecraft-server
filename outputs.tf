output "minecraft-server" {
  value = "${digitalocean_droplet.minecraft_server.ipv4_address}"
}

