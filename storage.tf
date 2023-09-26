#buckets com bloqueio de acesso público 
module "bucket1" {
  source   = "./modules/storage/"
  name     = "nome"
  region   = var.region
  }

module "bucket2" {
  source   = "./modules/storage/"
  name     = "nome2"
  region   = var.region
  }


