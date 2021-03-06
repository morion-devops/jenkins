############
# provider #
############
provider "google" {
  credentials = file("../credentials/.gcp-creds.json")

  project = "${var.GCP_PROJECT}"
  region  = "${var.GCP_REGION}"
  zone    = "${var.GCP_ZONE}"
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

variable "GCP_ZONE" {
  type = string
}

variable "GCP_REGION" {
  type = string
}

variable "GCP_PROJECT" {
  type = string
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
    access_config {
      nat_ip = google_compute_address.jenkins-master.address
      network_tier = "STANDARD"
    }
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
    access_config {
      network_tier = "STANDARD"
    }
  }
}

#############
# addresses #
#############
resource "google_compute_address" "jenkins-master" {
  region       = "europe-north1"
  name         = "jenkins-master"
  address_type = "EXTERNAL"
  network_tier = "STANDARD"
}