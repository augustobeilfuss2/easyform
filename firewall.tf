module "firewall_rules" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = var.project_id
  network_name = var.vpcname

  rules = [{
    name                    = "allow-${var.vpcname}-all-internal"
    description             = "Default allow internal"
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["IP"]
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
 ]


}
