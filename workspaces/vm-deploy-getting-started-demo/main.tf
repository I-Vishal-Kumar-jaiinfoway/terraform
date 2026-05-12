variable "project" {
  description = "GCP project ID"
  type        = string
  default     = "aerial-chimera-321316"
}

provider "google" {
  project = var.project
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_instance" "getting_started" {
  name         = "getting-started-demo"
  machine_type = "e2-small"
  zone         = "us-central1-a"
  tags         = ["http-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 20
      type  = "pd-balanced"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    enable-oslogin = "TRUE"
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    set -e
    set -o pipefail
    apt-get update -y
    apt-get install -y git docker.io
    systemctl enable --now docker
    git clone --depth=1 https://github.com/docker/getting-started.git /opt/app
    cd /opt/app
    docker build -t app:latest .
    docker run -d --restart=always --name app -p 80:3000 app:latest
    sleep 5
    curl -sI http://localhost:80/ || echo "WARN: app not responding"
  EOT

  service_account {
    scopes = ["cloud-platform"]
  }

  labels = {
    managed-by = "intellibooks-agent"
  }
}

resource "google_compute_firewall" "allow_http" {
  name    = "default-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
  direction     = "INGRESS"
  priority      = 1000
  description   = "Allow HTTP traffic to VMs tagged http-server"
}
