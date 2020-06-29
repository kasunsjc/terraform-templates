provider "azurerm" {
  features {}
}
resource "random_string" "random_suffix" {
  length  = 5
  special = false
  number  = false
  upper   = false
}

resource "azurerm_log_analytics_workspace" "web_app_loganalytics" {
  location            = var.region
  name                = var.log_analytics_workspace_name
  resource_group_name = var.rg_name
  sku                 = var.log_analytics_sku
  retention_in_days   = "30"
}

resource "azurerm_application_insights" "web_app_app_insights" {
  name                = "${var.app_insights}-${random_string.random_suffix.result}"
  location            = var.region
  resource_group_name = var.rg_name
  application_type    = "web"
  retention_in_days = "30"
}
