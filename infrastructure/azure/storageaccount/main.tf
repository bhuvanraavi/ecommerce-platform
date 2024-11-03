provider "azurerm" {
  features {

  }
}
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location

  tags = var.common_tags
}

data "azurerm_virtual_network" "example" {
  name                = "production"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_policy_definition" "example" {
  name         = "only-deploy-in-Canada-Central"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "my-policy-definition"

  policy_rule = <<POLICY_RULE
 {
    "if": {
      "not": {
        "field": "location",
        "equals": "Canada Central"
      }
    },
    "then": {
      "effect": "Deny"
    }
  }
POLICY_RULE
}

resource "azurerm_resource_policy_assignment" "example" {
  name                 = "example-policy-assignment"
  resource_id          = data.azurerm_virtual_network.example.id
  policy_definition_id = azurerm_policy_definition.example.id
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
    OwnerEmail = "BhuvanRavi09@gmail.com"
  })
}
resource "azurerm_storage_container" "example" {
  name                  = var.azurerm_storage_container_name
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"

}