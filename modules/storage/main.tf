resource "google_storage_bucket" "storage" {
  name          = var.name
  location      = var.region
  storage_class = ""
  public_access_prevention = "enforced"
}


