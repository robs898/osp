provider "google" {
  credentials = "${file("~/Documents/account.json")}"
  project     = "rm-dev-1"
  region      = "europe-west2"
}

resource "google_compute_network" "stream1" {
  name = "stream1-network"
}

resource "google_compute_firewall" "stream1" {
  name    = "stream1-firewall"
  network = "${google_compute_network.stream1.name}"

  allow {
    protocol = "udp"
    ports    = ["8888"]
  }
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["stream"]
}

resource "google_compute_instance" "stream1" {
  name         = "stream1-instance"
  machine_type = "n1-standard-1"
  zone         = "europe-west2-b"

  tags = ["stream"]

  boot_disk {
    initialize_params {
      image = "packer-1547239711"
    }
  }

  network_interface {
    network = "stream1-network"

    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = "ffmpeg -i udp://localhost:8888 /dev/shm/index.m3u8"

}
