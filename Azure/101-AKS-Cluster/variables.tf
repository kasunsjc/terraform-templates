#Variable
variable "arm_client_id" {
}

variable "arm_client_secret" {
}

variable "location" {
}

variable "cluster_name" {
}

variable "dns_prifix" {
}

variable "agent_count" {
    default = 3
}

variable "resource_group_name" {
}

variable "log_analytics_workspace_name" {

}
variable "log_analytics_workspace_location" {
    default = "eastus"
}
variable "log_analytics_workspace_sku" {
    default = "PerNode"
}

