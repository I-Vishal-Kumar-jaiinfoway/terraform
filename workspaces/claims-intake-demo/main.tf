provider "google" {
  project = "aerial-chimera-321316"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_instance" "claims_intake_demo" {
  name         = "claims-intake-demo"
  machine_type = "e2-small"
  zone         = "us-central1-a"
  labels = {
    managed-by = "intellibooks-agent"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 20
      type  = "pd-balanced"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral external IP
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    set -e
    apt-get update
    apt-get install -y docker.io
    systemctl enable --now docker
    docker run -d --restart=always -p 80:80 --name claims-intake nginxdemos/hello
  EOT
}

resource "google_compute_firewall" "claims_intake_demo_http" {
  name    = "claims-intake-demo-http"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["[REDACTED_IP]/0"]
  target_tags   = []
  direction    = "INGRESS"
  priority     = 1000
  description  = "Allow HTTP from [REDACTED_IP]/0 to claims-intake-demo VM"
}
