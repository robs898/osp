provider "google" {
  credentials = "${file("/Users/rma32/Documents/account.json")}"
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
    ports    = ["8888", "1935"]
  }
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "1935"]
  }

  target_tags = ["stream"]
  depends_on = ["google_compute_network.stream1"]
}

resource "google_compute_instance" "input1" {
  name         = "input1-instance"
  machine_type = "n1-standard-4"
  zone         = "europe-west2-b"

  allow_stopping_for_update = true
  tags = ["stream"]
  depends_on = ["google_compute_network.stream1"]

  boot_disk {
    initialize_params {
      image = "packer-1548062144"
    }
  }

  network_interface {
    network = "stream1-network"

    access_config {
      // Ephemeral IP
    }
  }
}

resource "google_compute_instance" "stream1" {
  name         = "stream1-instance"
  machine_type = "n1-standard-4"
  zone         = "europe-west2-b"

  allow_stopping_for_update = true
  tags = ["stream"]
  depends_on = ["google_compute_network.stream1"]

  boot_disk {
    initialize_params {
      image = "packer-1548062144"
    }
  }

  network_interface {
    network = "stream1-network"

    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = <<EOF
ffmpeg -re -i udp://localhost:8888 \
       -s 1280x720 -hls_time 4 /dev/shm/03.m3u8 \
       -s 640x480 -hls_time 4 /dev/shm/02.m3u8 \
       -s 320x240 -hls_time 4 /dev/shm/01.m3u8
EOF
}
