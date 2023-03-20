terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.6.0"
    }
  }
}

provider "digitalocean" {
  token = "dop_v1_cedbc080e95b2f2a7535554bde05cc51849610f1ae7193cfba52e1ff684c3397"
}

data "digitalocean_ssh_key" "josue" {
  name= "jb8"
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
