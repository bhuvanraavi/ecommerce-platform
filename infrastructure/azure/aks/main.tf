provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "default" {
  name     = "${var.name}-${var.environment}-rg"
  location = var.location
  tags     = var.common_tags
}

data "azurerm_subscription" "current" {}