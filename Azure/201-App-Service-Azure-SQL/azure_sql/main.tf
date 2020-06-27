provider "azurerm" {
  features {}
}

# Provision Azure SQL DB server instance
resource "azurerm_sql_server" "webapp_sqlserver" {
  name                         = "${var.sql_svr_name}-sqlserver"
  location                     = var.region
  resource_group_name          = var.rg_name
  version                      = "12.0"
  administrator_login          = var.sql_master_username
  administrator_login_password = var.sql_master_password
}

# Provision the Azure SQL Database (products database)
resource "azurerm_sql_database" "webapp_sqldb" {
  name                = "${var.sqldb_name}-sqldb"
  location            = var.region
  resource_group_name = var.rg_name
  server_name         = azurerm_sql_server.webapp_sqlserver.name
}