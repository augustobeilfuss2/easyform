module "sql" {
  source   = "./modules/sql/"
  namedb = "easy-db"
  namedb_instance = "easydb"

  #db-custom-numerodeCPU-memRAM*1024
  tier = "db-custom-12-61440"
  network = "projects/${var.project_id}/global/networks/${var.vpcname}"

}

