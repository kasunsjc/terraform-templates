provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_name" {
  location = var.region
  name = "${var.rg_name}-rg"
}


module "app_service" {
  source = "./app_service"
  app_service_plan_name = var.app_service_plan_name
  app_service_plan_size = var.app_service_plan_size
  app_service_plan_sku = var.app_service_plan_sku
  region = var.region
  web_app_name = var.web_app_name
  api_app_name = var.api_app_name
  app_runtime_version = var.app_runtime_version
  rg_name = azurerm_resource_group.rg_name.name
  sql_db_name = module.sql_server.sql_db_name
  sql_server_fqdn = module.sql_server.sql_server_fqdn
  sql_server_password = module.sql_server.sql_server_password
  sql_server_username = module.sql_server.sql_server_username
}

module "sql_server" {
  source = "./azure_sql"
  sql_svr_name = var.sql_svr_name
  rg_name = azurerm_resource_group.rg_name.name
  region = var.region
  sql_master_password = var.sql_master_password
  sql_master_username = var.sql_master_username
  sqldb_name = var.sqldb_name
}

