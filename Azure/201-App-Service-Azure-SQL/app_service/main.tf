provider "azurerm" {
  features {}
}


resource "random_string" "random_suffix" {
  length  = 5
  special = false
  number  = false
  upper   = false
}


resource "azurerm_app_service_plan" "app_service_plan" {
  location            = var.region
  name                = var.app_service_plan_name
  resource_group_name = var.rg_name
  sku {
    size = var.app_service_plan_sku
    tier = var.app_service_plan_size
  }

  tags = {
    env = "Prod"
  }

}

resource "azurerm_app_service" "web_frontend" {
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
  location            = var.region
  name                = "${var.web_app_name}-${random_string.random_suffix.result}"
  resource_group_name = var.rg_name
  depends_on          = [azurerm_storage_account.web_apps_logs]

  site_config {
    dotnet_framework_version = var.app_runtime_version
    always_on                = true
    default_documents = [
      "Default.htm",
      "Default.html",
      "hostingstart.html"
    ]
  }

  logs {
    application_logs {
      azure_blob_storage {
        level = "Error"
        retention_in_days = 180
        sas_url = data.azurerm_storage_account_sas.storage_sas.connection_string
      }
    }
    http_logs {
      azure_blob_storage {
        retention_in_days = 180
        sas_url = data.azurerm_storage_account_sas.storage_sas.connection_string
      }
    }
  }

  tags = {
    env = "Prod"
  }

}

resource "azurerm_app_service" "api_app" {
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
  location            = var.region
  name                = "${var.api_app_name}-${random_string.random_suffix.result}"
  resource_group_name = var.rg_name
  depends_on          = [azurerm_storage_account.web_apps_logs]

  site_config {
    dotnet_framework_version = var.app_runtime_version
    always_on                = true
    default_documents = [
      "Default.htm",
      "Default.html",
      "hostingstart.html"
    ]
  }

#This should be added later, beacause sas url can't generated from azurerm module
logs {
  application_logs {
    azure_blob_storage {
      level = "Error"
      retention_in_days = 180
      sas_url = data.azurerm_storage_account_sas.storage_sas.connection_string
    }
  }
  http_logs {
    azure_blob_storage {
      retention_in_days = 180
      sas_url = data.azurerm_storage_account_sas.storage_sas.connection_string
    }
  }
}


  app_settings = {
    "SqlConnectionString" = "Server=tcp:${var.sql_server_fqdn},1433;Initial Catalog=${var.sql_db_name};Persist Security Info=False;User ID=${var.sql_server_username};Password=${var.sql_server_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  tags = {
    env = "Prod"
  }
}

resource "azurerm_storage_account" "web_apps_logs" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = var.region
  name                     = "weapplogs${random_string.random_suffix.result}"
  resource_group_name      = var.rg_name

  tags = {
    env = "Prod"
  }

}

data "azurerm_storage_account_sas" "storage_sas" {
  depends_on = [azurerm_storage_account.web_apps_logs]
  connection_string = azurerm_storage_account.web_apps_logs.primary_blob_connection_string
  expiry            = "2020-07-19T00:00:00Z"
  start             = "2100-07-19T00:00:00Z"
  permissions {
    add     = true
    create  = true
    delete  = true
    list    = true
    process = true
    read    = true
    update  = true
    write   = true
  }
  resource_types {
    container = true
    object    = true
    service   = false
  }
  services {
    blob  = true
    file  = false
    queue = false
    table = false
  }
}