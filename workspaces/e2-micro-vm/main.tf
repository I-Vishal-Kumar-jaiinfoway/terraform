provider "google" {
  project = "aerial-chimera-321316"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_instance" "e2_micro_vm" {
  name         = "e2-micro-vm-01"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  tags = ["managed-by-intellibooks-agent"]
  labels = {
    managed-by = "intellibooks-agent"
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
      size  = 10
      type  = "pd-balanced"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}
