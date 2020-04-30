provider "random" {
  version = "~> 2.2"
}

resource "random_id" "instance_name_suffix" {
  byte_length = 5
}

resource "google_sql_database_instance" "testdbinstance" {
  name   = "mysql-db-${random_id.instance_name_suffix.hex}"
  region = "europe-west2"
  project = "terraform-automation-001"
  database_version = "MYSQL_5_7"

  settings {
    tier = "db-f1-micro"
    activation_policy = "ALWAYS"
    disk_autoresize = true
    disk_size = 10
    disk_type = "PD_SSD"
    pricing_plan = "PER_USE"

    location_preference {
      zone = "europe-west2-b"
    }

    database_flags {
      name = "log_bin_trust_function_creators"
      value = "on"
    }

    ip_configuration {
      ipv4_enabled = "true"
      authorized_networks {
        value = var.gcp_compute_engine_ip
      }
    }
  }
}

resource "google_sql_database" "testdatabase" {
  name     = "mysql-database"
  instance = google_sql_database_instance.testdbinstance.name
  project = "terraform-automation-001"
  charset = ""
  collation = ""
}


resource "google_sql_user" "my_sql_db" {
  name = "root"
  project = "terraform-automation-001"
  instance = google_sql_database_instance.testdbinstance.name
  host = "%"
  password = "root"
}

resource "google_compute_firewall" "http-mysql" {
  name = "default-firewall-mysql-port"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["3306"]
  }
}