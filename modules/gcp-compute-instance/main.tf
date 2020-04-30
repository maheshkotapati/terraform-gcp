resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
}

resource "google_compute_address" "static_external" {
  name = "ipv4-address-terraform"
}

data "google_compute_image" "centos_image" {
  family = var.gcp_vm_os
  project = var.gcp_vm_family
}

resource "google_compute_instance" "default" {
  machine_type = var.gcp_vm_machine_type # https://cloud.google.com/compute/docs/machine-types
  name = var.gcp_vm_instance_name
  labels = var.gcp_compute_engine_labels
  tags = ["http", "https", "ssh"]

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
      nat_ip = google_compute_address.static_external.address
    }
  }
}

resource "google_compute_firewall" "allow-http" {
  name    = "test-firewall-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["9001"]
  }
  target_tags = ["http"]
}

resource "google_compute_firewall" "allow-https" {
  name    = "test-firewall-https"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["9002"]
  }
  target_tags = ["https"]
}
resource "google_compute_firewall" "allow-ssh" {
  name    = "test-firewall-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
}

output "gcp-instance-external-ip" {
  value = google_compute_address.static_external.address
}