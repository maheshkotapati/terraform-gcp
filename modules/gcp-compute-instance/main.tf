data "google_compute_image" "centos_image" {
  family = var.gcp_vm_os
  project = var.gcp_vm_family
}

resource "google_compute_address" "static" {
  name = "ipv4-address-terraform"
}

resource "google_compute_instance" "default" {
  machine_type = var.gcp_vm_machine_type # https://cloud.google.com/compute/docs/machine-types
  name = var.gcp_vm_instance_name
  labels = var.gcp_compute_engine_labels

  boot_disk {
    initialize_params {
      image = data.google_compute_image.centos_image.self_link
      type = var.gcp_vm_disk_type # May be set to pd-standard or pd-ssd.
      size = var.gcp_vm_disk_size_in_gb
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
}

resource "google_compute_firewall" "http" {
  name    = "test-firewall-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }
  target_tags = ["http-server"]
}

resource "google_compute_firewall" "https" {
  name    = "test-firewall-https"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags = ["https-server"]
}

resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
}
