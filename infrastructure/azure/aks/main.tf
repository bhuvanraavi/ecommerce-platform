provider "azurerm" {
  features {}
  # subscription_id = "c20c5619-881c-43b4-ba94-880f0d2f333e"
}

# terrascan: ignore
resource "azurerm_resource_group" "default" {
  name     = "${var.name}-${var.environment}-rg"
  location = var.location
  tags     = var.common_tags
}

data "azurerm_subscription" "current" {}