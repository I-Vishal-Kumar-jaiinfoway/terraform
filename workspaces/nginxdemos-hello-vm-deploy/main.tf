provider "google" {
  project = "aerial-chimera-321316"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_instance" "nginxdemos_hello" {
  name         = "nginxdemos-hello-vm"
  machine_type = "e2-micro"
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
    apt-get install -y docker.io
    systemctl enable --now docker
    docker run -d --restart=always --name hello -p 80:80 nginxdemos/hello
    sleep 5
    curl -sI http://localhost:80/ || echo "WARN: app not responding"
  EOT

  service_account {
    scopes = ["cloud-platform"]
  }

  labels = {
    "managed-by" = "intellibooks-agent"
  }
}
