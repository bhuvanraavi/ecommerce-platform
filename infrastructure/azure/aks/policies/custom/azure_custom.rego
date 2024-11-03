package custom.azure

# Scenario 1: Ensure that Azure Storage Accounts use HTTPS
deny["Azure Storage Accounts must use HTTPS"] {
    input.resource.type == "azurerm_storage_account"
    input.resource.values.enable_https_traffic_only != true
}

# Scenario 2: Ensure that Azure Virtual Machines have a specific SKU
deny["Azure VMs must use approved SKU"] {
    input.resource.type == "azurerm_virtual_machine"
    not input.resource.values.sku in ["Standard_DS1_v2", "Standard_DS2_v2"]
}

# Scenario 3: Ensure that Network Security Groups have at least one inbound rule
deny["NSGs must have at least one inbound rule"] {
    input.resource.type == "azurerm_network_security_group"
    count(input.resource.values.security_rule) == 0
}

# Scenario 4: Ensure Azure Key Vaults have soft delete enabled
deny["Azure Key Vaults must have soft delete enabled"] {
    input.resource.type == "azurerm_key_vault"
    input.resource.values.enable_soft_delete != true
}

# Scenario 5: Ensure Azure SQL Databases have threat detection enabled
deny["Azure SQL Databases must have threat detection enabled"] {
    input.resource.type == "azurerm_sql_database"
    input.resource.values.threat_detection_policy.state != "Enabled"
}
