resource "google_sql_database" "database" {
  name     = var.namedb
  instance = google_sql_database_instance.instance.name
}
#lista de vulnerabilidades para o CloudSQL
#https://cloud.google.com/security-command-center/docs/concepts-vulnerabilities-findings#sql-findings
resource "google_sql_database_instance" "instance" {
  name             = var.namedb_instance
  region           = "us-central1"
  database_version = "POSTGRES_14"
  settings {
    tier = var.tier
    ip_configuration {
#instancia privada, sem exposição à internet e conectada somente a vpc criada.        
      ipv4_enabled                                  = false
      private_network                               = var.network
      enable_private_path_for_google_cloud_services = true
#enforced ssl
      require_ssl = "true" 
    }
#configuração de backup para o banco
    backup_configuration {
      enabled = true
      start_time = "01:00"
      location="us-central1"
    }
  }

  deletion_protection  = "true"
}