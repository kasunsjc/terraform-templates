provider "azurerm" {
}
resource "azurerm_resource_group" "storage-rg" {
  name = "${var.rg_name}"
  location = "${var.location}"
}
resource "azurerm_storage_account" "storage-account" {
  name = "${lower(var.storage_account_name)}"
  resource_group_name = "${azurerm_resource_group.storage-rg.name}"
  account_kind = "${var.account_kind}"
  access_tier = "${var.access_tier}"
  account_tier = "${var.account_tier}"
  account_replication_type = "${var.replication_type}"
  location = "${azurerm_resource_group.storage-rg.location}"
  tags ={
    env = "staging"
  }
}
