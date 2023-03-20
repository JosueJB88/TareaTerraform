terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.6.0"
    }
  }
}

provider "digitalocean" {
  token = "dop_v1_33f3baa138b8019c5d87dea4f0777d2a0e965f1295530e5de3f67bbd6e422a4b"
}

data "digitalocean_ssh_key" "josue" {
  name= "jb"
  #public_key = file("~/.ssh/id_rsa.pub")
}


resource "digitalocean_droplet" "example" {
  image  = "ubuntu-20-04-x64"
  name   = "mjb"
  region = "nyc1"
  size   = "s-1vcpu-1gb"
  ssh_keys = [
    data.digitalocean_ssh_key.josue.id
  ]
  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "2m"
    host     = self.ipv4_address
  }


provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y git",
      "apt-get update",
      "snap install docker          # version 20.10.17",
      "git clone https://github.com/JosueJB88/PostgreSQL.git",
      "cd PostgreSQL",
      "docker-compose up"
    ]
  }

}