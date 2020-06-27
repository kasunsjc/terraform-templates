output "sql_server_fqdn" {
  value = azurerm_sql_server.webapp_sqlserver.fully_qualified_domain_name
}

output "sql_db_name" {
  value = azurerm_sql_database.webapp_sqldb.name
}

output "sql_server_username" {
  value = azurerm_sql_server.webapp_sqlserver.administrator_login
}

output "sql_server_password" {
  value = azurerm_sql_server.webapp_sqlserver.administrator_login_password
}