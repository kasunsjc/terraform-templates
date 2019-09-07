/*
*Author - Kasun Rajapakse
*Subject - Create Storage Account
*Language - HCL 
! Last Modify Date - Sep 7 2019
! Disclaimer- EGAL DISCLAIMER
This Sample Code is provided for the purpose of illustration only and is not
intended to be used in a production environment.  THIS SAMPLE CODE AND ANY
RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.  We grant You a
nonexclusive, royalty-free right to use and modify the Sample Code and to
reproduce and distribute the object code form of the Sample Code, provided
that You agree: (i) to not use Our name, logo, or trademarks to market Your
software product in which the Sample Code is embedded; (ii) to include a valid
copyright notice on Your software product in which the Sample Code is embedded;
and (iii) to indemnify, hold harmless, and defend Us and Our suppliers from and
against any claims or lawsuits, including attorneys’ fees, that arise or result
from the use or distribution of the Sample Code. 
*/

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
