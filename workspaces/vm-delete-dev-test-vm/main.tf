provider "google" {
  project = "aerial-chimera-321316"
  region  = "us-central1"
  zone    = "us-central1-a"
}

# No resources defined: this signals terraform to delete the VM previously managed in this workspace
