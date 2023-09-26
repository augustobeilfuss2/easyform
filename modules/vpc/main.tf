resource "google_compute_network" "vpc_network" {
  project                                   = var.project_id
  name                                      = var.vpcname
  auto_create_subnetworks                   = false
  #autocreate precisa estar desabilitado para não criar subnetworks pré-configuradas em todas as regiões
  #https://cloud.google.com/vpc/docs/vpc?hl=pt-br#auto-mode-considerations
  #https://cloud.google.com/security-command-center/docs/concepts-vulnerabilities-findings?hl=pt-br#network-findings
}
resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "sub"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network.id
  #é declarado ranges secundários para pods e serviços no gke, os cidr primário é para os nodes e máquinas.
  #https://cloud.google.com/kubernetes-engine/docs/concepts/alias-ips#benefits
  secondary_ip_range {
    range_name    = "range-services"
    ip_cidr_range = "10.3.10.0/24"
  }
    secondary_ip_range {
    range_name    = "range-pods"
    ip_cidr_range = "10.4.10.0/24"
  }
}

#configuração do private service connection, responsável por conectar os serviços da google com as máquinas do compute
resource "google_compute_global_address" "private_ip_block" {
  name          = "service-connection"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  ip_version    = "IPV4"
  prefix_length = 24
  network       = google_compute_network.vpc_network.id
}
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_block.name]
}

#configuração padrão de regras de firewall que habilitam comunicação interna e conexão via IAP
module "firewall_rules_default" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = var.project_id
  network_name = var.vpcname

  rules = [{
    name                    = "allow-${var.vpcname}-all-internal"
    description             = "Default allow internal"
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["10.2.0.0/16" ,"10.3.10.0/24","10.4.10.0/24"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = null
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["1-65535"]
    },
    { protocol  = "udp"
      ports     = ["1-65535"]
    },
    { protocol = "icmp"
      ports    = []
    }
    ]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  },
  {
    name                    = "allow-${var.vpcname}-iap"
    description             = "Default allow iap"
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["35.235.240.0/20"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = null
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["22,3389"]
    },
    ]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  },
 ]


}
