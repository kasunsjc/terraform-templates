variable "region" {
  description = "Location of the App Service Plan"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan"
}

variable "rg_name" {
  description = "Resource Group Name"
}

variable "app_service_plan_sku" {
  description = "SKU of the App Service Plan (Basic,Standard,Premium)"
}

variable "app_service_plan_size" {
  description = "Size of the App Service Plan (S1,S2 etc)"
}

variable "web_app_name" {
  description = "Front end Web App Name"
}

variable "app_runtime_version" {
  description = "Application Runtime Version .Net, Java or PHP"
}

variable "api_app_name" {
  description = "API Application for the .Net App"
}

variable "sql_server_fqdn" {
  description = "FQDN of the SQL server"
}

variable "sql_db_name" {
  description = "SQL DB Name"
}

variable "sql_server_username" {
  description = "SQL Server Username"
}

variable "sql_server_password" {
  description = "SQL Server Password"
}
