provider "google" {
  credentials = "${file("/Users/rma32/Documents/account.json")}"
  project     = "rm-dev-1"
  region      = "europe-west2"
}

resource "google_compute_network" "stream2" {
  name = "stream2-network"
}

resource "google_compute_firewall" "stream2" {
  name    = "stream2-firewall"
  network = "${google_compute_network.stream2.name}"

  allow {
    protocol = "udp"
    ports    = ["8888"]
  }
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["stream2-firewall"]
}

resource "google_compute_instance" "stream2" {
  name         = "stream2-instance"
  machine_type = "n1-standard-1"
  zone         = "europe-west2-b"

  tags = ["stream2-firewall"]

  boot_disk {
    initialize_params {
      image = "packer-1547244048"
    }
  }

  network_interface {
    network = "stream2-network"

    access_config {
      // Ephemeral IP
    }
  }

  //metadata_startup_script = "ffmpeg -i udp://localhost:8888 /dev/shm/index.m3u8"

}
