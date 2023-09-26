variable "instance_name" {}
variable "region" {}
variable "description" {}
variable "instance_zone" {}
variable "instance_type" {}
variable "instance_network" {}
variable "instance_subnetwork" {}
variable "internal_ip" {}
variable "image" {}
variable "disk_size" {}
variable "disk_type" {
  default = "PD_SSD"
}
variable "metadata_script" {
  default = ""
}
variable "name-sa" {}
variable "display_name-sa" {}
variable "use_public_ip" {
  description = "Utilizar Ip Publico"
  type        = bool
}
variable "tags" {
  description = "Lista de tags"
  type        = list(string)
}

