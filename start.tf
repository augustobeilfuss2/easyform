
#log bucket 
#https://cloud.google.com/security-command-center/docs/concepts-vulnerabilities-findings?hl=pt-br#logging-findings
resource "google_storage_bucket" "storage" {
  name          = "storage_logs_bucket"
  location      = var.region
  storage_class = ""
  public_access_prevention = "enforced"
}

module "log_export" {
  source                 = "terraform-google-modules/log-export/google"
  version                = "~> 7.0"
  destination_uri        = "${module.destination.destination_uri}"
  filter                 = ""
  log_sink_name          = "all_logs_export"
  parent_resource_id     = var.project_id
  parent_resource_type   = var.project_id
  unique_writer_identity = true
}

module "destination" {
  source                   = "terraform-google-modules/log-export/google//modules/storage"
  version                  = "~> 7.0"
  project_id               = var.project_id
  storage_bucket_name      = "storage_logs_bucket"
  log_sink_writer_identity = "${module.log_export.writer_identity}"
  #depends_on = [ module.log_export ]
}