module "vpc" {
  source   = "./modules/vpc/"
  vpcname     = var.vpcname
  region   = var.region
  project_id  = var.project_id
  }


