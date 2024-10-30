variable "location" {
  type    = string
  default = "Canada Central"
}
variable "prefix" {
  type    = string
  default = "AKS"
}
variable "resource_group_name" {
  type    = string
  default = "tfstate"
}
variable "storageaccountname" {
  type    = string
  default = "tfstateravi2408"
}
variable "account_tier" {
  type    = string
  default = "Standard"
}
variable "account_replication_type" {
  type    = string
  default = "LRS"
}
variable "azurerm_storage_container_name" {
  type    = string
  default = "tfstate"
}


variable "common_tags" {
  type = map(string)
  default = {
    Environment = "Development"
    Application = "Azure Compliance"
    Creator     = "Azure Compliance"
    Role        = "Azure Compliance"
  }
}