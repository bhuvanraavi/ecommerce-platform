# tfsec:ignore:azure-container-limit-authorized-ips
resource "azurerm_kubernetes_cluster" "default" {
  name                              = "${var.name}-aks"
  location                          = azurerm_resource_group.default.location
  resource_group_name               = azurerm_resource_group.default.name
  dns_prefix                        = "${var.dns_prefix}-${var.name}-aks-${var.environment}"
  depends_on                        = [azurerm_role_assignment.default]
  role_based_access_control_enabled = true
  # api_server_authorized_ip_ranges = [ "10.0.0.0/8" ]

  # api_server_access_profile {
  #   authorized_ip_ranges = ["10.1.0.0/16", "10.0.0.0/8"]
  # }

  default_node_pool {
    name            = "default"
    node_count      = var.node_count
    vm_size         = var.node_type
    os_disk_size_gb = 30
    vnet_subnet_id  = azurerm_subnet.aks.id
  }
  linux_profile {
    admin_username = var.username
    ssh_key {
      key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
    }
  }
  service_principal {
    client_id     = azuread_application.default.client_id
    client_secret = azuread_service_principal_password.default.value
  }
  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id
  }
  tags = var.common_tags
}