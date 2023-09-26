#Configure the Google Cloud provider
provider "google" {
 credentials = file("easyform.json")
 project     = var.project_id
} 
provider "google-beta" {
 credentials = file("easyform.json")
 project     = var.project_id
}

terraform {
  backend "gcs" {
    bucket  = "easyform-bucket"
    prefix  = "terraform/state"
    credentials = "easyform.json"
     }
  }
