provider "google" {
}

resource "random_id" "service_account_name" {
  byte_length = 8
}

module "google_service_account" {
  source     = "../../"
  project_id = var.project_id
  name       = "sa-test-${random_id.service_account_name.hex}"
}
