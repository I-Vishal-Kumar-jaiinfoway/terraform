provider "google" {
  project = "aerial-chimera-321316"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_instance" "getting_started" {
  name         = "getting-started"
  machine_type = "e2-small"
  zone         = "us-central1-a"
  tags         = ["http-server", "managed-by-intellibooks-agent"]

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
    export DOCKER_BUILDKIT=1
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

resource "google_compute_firewall" "allow_http_getting_started" {
  name    = "allow-http-getting-started"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
  priority      = 1000
  description   = "Allow inbound HTTP traffic on port 80 for getting-started VM"
}
