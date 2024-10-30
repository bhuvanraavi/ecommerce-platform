provider "azurerm" {
  features {

  }
}
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location

  tags = var.common_tags
}

resource "azurerm_storage_account" "example" {
  name                     = var.storageaccountname
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  # Optional: Enable blob versioning for extra state safety
  blob_properties {
    versioning_enabled = true
  }

  tags = merge(var.common_tags, {
    Owner = "Bhuvan Ravi"
  })
}
resource "azurerm_storage_container" "example" {
  name                  = var.azurerm_storage_container_name
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}