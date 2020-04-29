variable "gcp_vm_os" {
  type = string
  description = "VM Instance Project i.e. type of OS"
}

variable "gcp_vm_family" {
  type = string
  description = "VM Instance Family"
}

variable "gcp_vm_machine_type" {
  type = string
  description = "GCP Machine Type eg: f1-micro, g1-small, n1-standard-1 & the list goes on...check documentation "
}

variable "gcp_vm_instance_name" {
  type = string
  description = "Name of the instance"
}

variable "gcp_vm_disk_type" {
  type = string
  description = "VM disk type # May be set to pd-standard or pd-ssd"
}

variable "gcp_vm_disk_size_in_gb" {
  type = string
  description = "VM Disk size in GB's"
}

variable "gcp_network_name" {
  type = string
  description = "Network Name"
}

variable "gcp_compute_engine_labels" {
  type = map(string)
  default = { environment = "default" }
}