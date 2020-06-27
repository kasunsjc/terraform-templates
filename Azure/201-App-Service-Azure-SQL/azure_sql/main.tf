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

  tags = {
    env = Prod
  }
}

# Provision the Azure SQL Database (products database)
resource "azurerm_sql_database" "webapp_sqldb" {
  name                = "${var.sqldb_name}-sqldb"
  location            = var.region
  resource_group_name = var.rg_name
  server_name         = azurerm_sql_server.webapp_sqlserver.name
  edition             = var.sqldb_edition
  requested_service_objective_name = "S0"

  extended_auditing_policy {
    storage_account_access_key = azurerm_storage_account.sql_auditing_sa.primary_access_key
    storage_endpoint = azurerm_storage_account.sql_auditing_sa.primary_blob_endpoint
    storage_account_access_key_is_secondary = true
    retention_in_days = 60
  }

  tags = {
    env = Prod
  }

}

resource "azurerm_sql_firewall_rule" "sql_svr_firewall" {
  name                = "${var.sql_svr_name}-sqlfirewall"
  resource_group_name = var.rg_name
  server_name         = azurerm_sql_server.webapp_sqlserver.name
  start_ip_address    = "0.0.0.0" #Dont put in production env
  end_ip_address      = "0.0.0.0" #Dont put in production env
}

resource "azurerm_storage_account" "sql_auditing_sa" {
  name                     = "${var.sql_svr_name}-audit-sa"
  resource_group_name      = var.rg_name
  location                 = var.region
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    env = Prod
  }

}
