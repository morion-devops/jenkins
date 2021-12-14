############
# provider #
############
provider "google" {
  credentials = file("../credentials/.gcp-creds.json")

  project = "prefab-poetry-334607"
  region  = "europe-north1"
  zone    = "europe-north1-a"
}

#############
# variables #
#############
variable "ssh_key_file_name" {
  default = "../credentials/.gcp_ssh.pub"
}

variable "ssh_user_name" {
  default = "gcp_jenkins"
}

#############
# instances #
#############
resource "google_compute_instance" "jenkins-master" {
  name         = "jenkins-master"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      type  = "pd-standard"
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user_name}:${file(var.ssh_key_file_name)}"
  }

  labels = {
    service_name = "jenkins"
    service_role = "master"
  }

  tags = ["http-server"]

  network_interface {
    network = "default"
    access_config {} // for external ip
  }
}

resource "google_compute_instance" "jenkins-node1" {
  name                      = "jenkins-node1"
  machine_type              = "e2-micro"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      type  = "pd-standard"
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user_name}:${file(var.ssh_key_file_name)}"
  }

  labels = {
    service_name = "jenkins"
    service_role = "node"
  }

  network_interface {
    network = "default"
    access_config {} // for external ip
  }
}
