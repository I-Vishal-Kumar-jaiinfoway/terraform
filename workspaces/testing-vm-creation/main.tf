provider "google" {
  project = "aerial-chimera-321316"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_instance" "testing-vm-creation" {
  name         = "testing-vm-creation"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  tags         = ["managed-by-intellibooks-agent"]

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2204-lts"
      size  = 20
      type  = "pd-balanced"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  labels = {
    managed-by = "intellibooks-agent"
  }
}
