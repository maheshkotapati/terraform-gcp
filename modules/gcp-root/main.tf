terraform {
  required_version = ">= 0.12"
  required_providers {
    google = ">= 3.18"
  }
}

provider "google" {
  credentials = file(var.gcp_compute_instance_auth_file)
  project = var.gcp_project_name
  region = var.gcp_region
  zone = var.gcp_zone
}

module "gcp-compute-instance" {
  source = "../gcp-compute-instance"

  gcp_vm_os = var.gcp_vm_os
  gcp_vm_family = var.gcp_vm_family
  gcp_vm_machine_type = var.gcp_vm_machine_type
  gcp_vm_instance_name = var.gcp_vm_instance_name
  gcp_vm_disk_type = var.gcp_vm_disk_type
  gcp_vm_disk_size_in_gb = var.gcp_vm_disk_size_in_gb
  gcp_network_name = var.gcp_network_name
  gcp_compute_engine_labels = var.gcp_compute_engine_labels
}

module "gcp-sql-database" {
  source = "../gcp-sql-database"
  gcp_compute_engine_ip = module.gcp-compute-instance.gcp-instance-external-ip
}