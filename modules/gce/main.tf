#Service account da máquina criada, a google recomenda que se tenha uma service account para cada máquina.
#https://cloud.google.com/compute/docs/access/service-accounts#associating_a_service_account_to_an_instance
resource "google_service_account" "gsa" {
  account_id   = var.name-sa
  display_name = var.display_name-sa
}

#Política de snapshot para a máquina criada
#
resource "google_compute_resource_policy" "policy" {
  name   = "schedule-${var.instance_name}"
  region = var.region
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "02:00"
      }
    }
    retention_policy {
      max_retention_days    = 7
      on_source_disk_delete = "APPLY_RETENTION_POLICY"
    }
  }
}

#Associa a política a vm
resource "google_compute_disk_resource_policy_attachment" "attachment_disk0" {
  name = google_compute_resource_policy.policy.name
  disk = google_compute_instance.vm_instance.name
  zone = var.instance_zone
}

#Verifica e cria o IP externo da máquina
resource "google_compute_address" "external" {
  count = var.use_public_ip ? 1 : 0
  name         = "${var.instance_name}-external"

  address_type = "EXTERNAL"
  region       = var.region
}
#Cria o IP externo da máquina
resource "google_compute_instance" "vm_instance" {
  name                      = var.instance_name
  zone                      = var.instance_zone
  machine_type              = var.instance_type
  tags                      = var.tags

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.disk_size
      type  = "pd_ssd"
    }
    auto_delete = true
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  network_interface {
    network = var.instance_network
  }

  service_account {
    email  = google_service_account.gsa.email
    scopes = ["cloud-platform"]
  }

  depends_on = [
    google_service_account.gsa
  ]
}
