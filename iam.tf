#principio de privilégio mínimo
#contas de serviço não devem posssuir acessos administrativos

module "projects_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.6"

  projects = [var.project_id]

  bindings = {

    "roles/compute.networkAdmin" = [
      "group:test_sa_group@lnescidev.com",
      "user:alguem@google.com",
    ]

    "roles/compute.imageUser" = [
      "user:alguem@google.com",
    ]
  }
}