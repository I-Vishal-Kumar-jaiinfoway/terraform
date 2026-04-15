provider "google" {
  project = "aerial-chimera-321316"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_instance" "dev-test-vm" {
  name         = "dev-test-vm"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  tags = ["dev", "test"]
  labels = {
    managed_by = "intellibooks-agent"
    env        = "dev"
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
      size  = 10
      type  = "pd-balanced"
    }
    auto_delete = true
  }

  network_interface {
    network = "default"
    access_config {}
  }
}
