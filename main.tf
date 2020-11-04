resource "digitalocean_droplet" "minecraft" {
  image    = "debian-10-x64"
  name     = "minecraft"
  region   = "fra1"
  size     = "2gb"
  ssh_keys = ["${var.ssh_fingerprint}"]

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file(var.pvt_key)
    host        = self.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update -y",
      "apt-get install default-jdk rsync -y",
      "mkdir /opt/minecraft"
    ]
  }

  provisioner "file" {
    source      = "minecraft/eula.txt"
    destination = "/opt/minecraft/eula.txt"
  }

  provisioner "file" {
    source      = "minecraft/server.properties"
    destination = "/opt/minecraft/server.properties"
  }

  provisioner "file" {
    source      = "minecraft/server.jar"
    destination = "/opt/minecraft/server.jar"
  }

  provisioner "local-exec" {
    command = "./syncworld.sh ${digitalocean_droplet.minecraft.ipv4_address}"
  }

  provisioner "file" {
    source      = "minecraft/minecraft.service"
    destination = "/usr/lib/systemd/system/minecraft.service"
  }

  provisioner "remote-exec" {
    inline = [
      "systemctl daemon-reload",
      "systemctl start minecraft.service"
    ]
  }

  provisioner "local-exec" {
    command = "./mapdns"
  }

}

