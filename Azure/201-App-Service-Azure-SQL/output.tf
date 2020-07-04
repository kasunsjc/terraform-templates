output "rg_name" {
  value = azurerm_resource_group.rg_name.name
}

output "sql_db_name" {
  value = module.sql_server.sql_db_name
}

output "sql_server_username" {
  value = module.sql_server.sql_server_fqdn
}