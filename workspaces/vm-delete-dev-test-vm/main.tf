provider "google" {
  project = "aerial-chimera-321316"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_instance" "dev_test_vm" {
  name         = "dev-test-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  count        = 0

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
      size  = 10
    }
    auto_delete = true
  }

  network_interface {
    network = "default"
    access_config {}
  }

  tags = ["dev", "test"]
  labels = {
    env                        = "dev"
    goog-terraform-provisioned = "true"
    managed_by                 = "intellibooks-agent"
  }
  metadata = {
    enable-oslogin = "TRUE"
  }
  lifecycle {
    prevent_destroy = false
  }
}
