resource "azuredevops_project" "project" {
  description        = "Created by Terraform"
  name               = "terraform-project"
  version_control    = "git"
  visibility         = "private"
  work_item_template = "Agile"
}

resource "azuredevops_git_repository" "git_repository" {
  project_id     = azuredevops_project.project.id
  name           = "terraform-repo"
  default_branch = "refs/heads/main"
  initialization {
    init_type = "Clean"
  }
  lifecycle {
    ignore_changes = [
      initialization
    ]
  }
}

resource "azuredevops_serviceendpoint_azurerm" "azure_service_connection" {
  project_id                             = azuredevops_project.project.id
  service_endpoint_name                  = "AzureRM-Create-Terraform"
  description                            = "Managed by Terraform"
  service_endpoint_authentication_scheme = "ServicePrincipal"
  credentials {
    serviceprincipalid  = "4f149c0e-5f8c-4020-921d-98d4e9c9651b"
    serviceprincipalkey = "6Uh8Q~99wjBBMX3iIDbYB.6Yjg~m8FKfC2yb.diH"
  }
  azurerm_spn_tenantid      = "67e62596-f24c-4eae-9a15-e9aa38182dfd"
  azurerm_subscription_id   = "dac4cab6-7da3-4bba-a0c6-b93e33e6717a"
  azurerm_subscription_name = "Created-By-Terraform"
}