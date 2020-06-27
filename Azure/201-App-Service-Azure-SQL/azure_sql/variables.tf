variable "sql_svr_name" {
  description = "SQL Server Name"
}
variable "rg_name" {
  description = "Resource Group Name"
}

variable "region" {
  description = "Location of the App Service Plan"
}

variable "sql_master_username" {
  description = "Master Username for SQl server"
}

variable "sql_master_password" {
  description = "Master password for SQL Server"
}

variable "sqldb_name" {
  description = "SQL Database name"
}