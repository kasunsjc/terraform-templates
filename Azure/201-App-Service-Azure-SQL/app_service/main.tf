provider "azurerm" {
  features {}
}

resource "azurerm_app_service_plan" "app_service_plan" {
  location            = var.region
  name                = var.app_service_plan_name
  resource_group_name = var.rg_name
  sku {
    size = var.app_service_plan_sku
    tier = var.app_service_plan_size
  }
}

resource "azurerm_app_service" "web_frontend" {
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
  location            = var.region
  name                = var.web_app_name
  resource_group_name = var.rg_name

  site_config {
    dotnet_framework_version = var.app_runtime_version
    always_on                = true
    default_documents = [
      "Default.htm",
      "Default.html",
      "hostingstart.html"
    ]
  }
}

resource "azurerm_app_service" "api_app" {
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
  location            = var.region
  name                = var.api_app_name
  resource_group_name = var.rg_name

  site_config {
    dotnet_framework_version = var.app_runtime_version
    always_on                = true
    default_documents = [
      "Default.htm",
      "Default.html",
      "hostingstart.html"
    ]
  }

  app_settings = {
    "SqlConnectionString" = "Server=tcp:${var.sql_server_fqdn},1433;Initial Catalog=${var.sql_db_name};Persist Security Info=False;User ID=${var.sql_server_username};Password=${var.sql_server_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}