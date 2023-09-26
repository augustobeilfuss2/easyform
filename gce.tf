module "instancia" {
  source              = "./modules/gce/"
  instance_name       = "nome"
  description         = "nome"
  region = var.region
  instance_zone       = var.zone
  instance_type       = "e2-medium"
  instance_subnetwork = "projects/${var.project_id}/regions/${var.region}/subnetworks/sub"
  instance_network = "projects/${var.project_id}/global/networks/${var.vpcname}"
  use_public_ip = true
  internal_ip = ""
  image = "imagem"
  disk_size = "127"
  tags = ["tag1", "tag2", "tag3"]
  name-sa ="instancia1"
  display_name-sa ="instancia1"
}
