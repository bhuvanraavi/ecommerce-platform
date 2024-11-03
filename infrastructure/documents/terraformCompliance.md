Terraform compliance involves ensuring that your Terraform infrastructure code adheres to your organization’s policies, security guidelines, and best practices. This helps enforce a standardized configuration across your infrastructure and ensures compliance with industry standards.

### Key Aspects of Terraform Compliance:

1. **Policy as Code (PaC):**
   - Policies can be defined as code, allowing automated checks during the infrastructure provisioning process. Examples of PaC tools include Open Policy Agent (OPA), HashiCorp Sentinel, and AWS Config.

2. **Compliance Tools for Terraform:**
   - **OPA (Open Policy Agent)**: OPA is an open-source policy engine that lets you enforce custom policies. It integrates with Terraform through tools like Conftest or by running OPA checks in CI/CD pipelines.
   - **Sentinel (HashiCorp’s Enterprise Tool)**: Sentinel, built into HashiCorp's Terraform Cloud and Enterprise versions, allows users to create policies that restrict certain configurations in their Terraform code.
   - **TerraScan**: TerraScan provides a set of rules to check against infrastructure code for misconfigurations, security violations, and compliance issues.
   - **Checkov**: Checkov is an open-source tool by Bridgecrew that scans for cloud infrastructure misconfigurations, detecting policy breaches for AWS, GCP, Azure, and Kubernetes.

3. **Best Practices:**
   - **Version Control and Modularization**: Use modularized Terraform code in a version control system to ensure traceability and make compliance checks easier.
   - **CI/CD Integration**: Automate compliance checks in your CI/CD pipeline to catch issues before deployment.
   - **Resource Constraints**: Enforce naming conventions, tagging, and permissions through policies to meet compliance standards.
   - **Auditing and Reporting**: Generate logs and compliance reports to document policy adherence and assist in audits.

4. **Example Use Case - Enforcing Compliance on `azuread_application` Resource:**
   - If you want to ensure `azuread_application` resources meet compliance, you could define policies to enforce naming conventions, required tags, specific configurations for sensitive settings, or restrictions on permissions.
   - Using OPA or Checkov, you can specify rules to check that `azuread_application` has required parameters configured to avoid security vulnerabilities.

`terraform-compliance` is a lightweight, open-source tool specifically built to perform compliance checks on Terraform plans. It enforces custom policies to ensure your infrastructure-as-code aligns with your organization’s standards before provisioning resources, giving you a way to define rules in a natural language, making compliance rules easy to write and understand.

### Key Features of `terraform-compliance`

1. **BDD-Style Syntax**: 
   - `terraform-compliance` uses a behavior-driven development (BDD) approach for defining policies. This makes the rules easy to read and write, as they’re structured similarly to natural language.

2. **Plan File Verification**:
   - It operates on Terraform plan files, meaning it checks what Terraform intends to change before applying the changes. This is a proactive way to prevent non-compliant resources from being deployed.

3. **Policy Enforcement**:
   - You can define policies for naming conventions, tagging standards, specific configurations, and much more. For instance, you could require that certain tags are present, or that specific configurations, like encryption, are enabled.

4. **Integration with CI/CD Pipelines**:
   - `terraform-compliance` can be easily integrated into CI/CD pipelines, so compliance checks are automated with every deployment, catching non-compliant code before it’s applied.

5. **Supports Multiple Cloud Providers**:
   - The tool supports multi-cloud compliance checks, as long as the resources are managed via Terraform.

### How to Use `terraform-compliance`

1. **Installation**:
   - Install via pip: `pip install terraform-compliance`

2. **Writing Compliance Tests**:
   - Create a folder for compliance tests (e.g., `features/`) and add `.feature` files. These files define compliance tests in BDD syntax.
   - Example test for ensuring all resources have tags:

     ```gherkin
     Feature: Ensure all resources have required tags

       Scenario: All resources must have the "Environment" tag
         Given I have resource that supports tags defined
         When it contains tags
         Then it must contain Environment
     ```

3. **Running Tests**:
   - Run the compliance check with the Terraform plan file as an argument:  
     ```bash
     terraform plan -out=tfplan
     terraform-compliance -p tfplan
     ```

4. **Interpreting Results**:
   - `terraform-compliance` will output pass/fail results based on the defined policies, allowing you to pinpoint non-compliant configurations before they reach production.

### Example Use Case for `azuread_application` Compliance

Suppose you need to enforce specific properties on `azuread_application` resources, such as required tags or configuration settings:

```gherkin
Feature: Enforce compliance on azuread_application resources

  Scenario: azuread_application resources must have an "Owner" tag
    Given I have azuread_application defined
    When it contains tags
    Then it must contain Owner
```

This example will check that every `azuread_application` resource includes an `Owner` tag.

### Best Practices with `terraform-compliance`

- **Modularize Policies**: Break down compliance tests into modular `.feature` files to make them more manageable.
- **Version Control**: Keep your compliance tests in version control alongside your Terraform code.
- **Use in CI/CD Pipelines**: Automate compliance checks by running `terraform-compliance` in your CI/CD pipeline.

`terraform-compliance` is an efficient way to ensure your Terraform-managed infrastructure adheres to policies without extensive custom tooling.

Here’s a step-by-step guide to setting up `terraform-compliance` with Terraform, focusing on multiple Azure resources, including Azure Kubernetes Service (AKS), Storage Accounts, and other Azure services. This will walk you through installing `terraform-compliance`, writing compliance tests, and enforcing compliance for an Azure-focused infrastructure.

---

### Step 1: Install `terraform-compliance`

1. **Ensure you have Python installed** since `terraform-compliance` is a Python package.
2. Install `terraform-compliance` via pip:

   ```bash
   pip install terraform-compliance
   ```

3. Verify the installation:

   ```bash
   terraform-compliance --version
   ```

---

### Step 2: Create a Terraform Project with Azure Resources

Create a Terraform configuration to provision Azure resources such as AKS, Storage Accounts, and other services. Here’s a sample Terraform code:

```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "exampleAKSCluster"
  location            = "East US"
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "exampledns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestorageacct"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

---

### Step 3: Write Compliance Tests with `terraform-compliance`

Create a folder named `features` to store the `.feature` files where you define compliance rules. Below are some example `.feature` files for specific Azure services.

---

#### Use Case 1: AKS - Ensure Specific Configuration for AKS Cluster

Ensure that AKS clusters have a specific `vm_size` for node pools, that they are assigned a `SystemAssigned` identity, and that they use the `standard` load balancer SKU.

1. Create a new file in the `features` folder, such as `aks_compliance.feature`.
2. Add the following test:

   ```gherkin
   Feature: Ensure compliance for AKS clusters

     Scenario: Enforce AKS node pool configuration
       Given I have azurerm_kubernetes_cluster defined
       When its default_node_pool.vm_size is defined
       Then it must be "Standard_DS2_v2"

     Scenario: Enforce AKS identity type
       Given I have azurerm_kubernetes_cluster defined
       When its identity.type is defined
       Then it must be "SystemAssigned"

     Scenario: Enforce AKS load balancer SKU
       Given I have azurerm_kubernetes_cluster defined
       When its network_profile.load_balancer_sku is defined
       Then it must be "standard"
   ```

---

#### Use Case 2: Storage Account - Enforce Encryption and Tags

Verify that all Storage Accounts have encryption enabled and that a specific set of tags are applied.

1. Create a file in the `features` folder, such as `storage_account_compliance.feature`.
2. Add the following test:

   ```gherkin
   Feature: Ensure compliance for Storage Accounts

     Scenario: Storage Account must have encryption enabled
       Given I have azurerm_storage_account defined
       When it contains enable_blob_encryption
       Then it must be true

     Scenario: Storage Account must contain specific tags
       Given I have azurerm_storage_account defined
       When it contains tags
       Then it must contain "Environment"
       And it must contain "Owner"
   ```

---

#### Use Case 3: General Azure Resources - Enforce Tags and Resource Group Naming Convention

Verify that all resources have a standard set of tags and belong to a resource group that follows a naming convention.

1. Create another file in the `features` folder, such as `general_azure_compliance.feature`.
2. Add the following test:

   ```gherkin
   Feature: Ensure tagging and naming conventions for Azure resources

     Scenario: All resources must have the "Environment" and "Department" tags
       Given I have resource that supports tags defined
       When it contains tags
       Then it must contain "Environment"
       And it must contain "Department"

     Scenario: Resource groups must follow naming conventions
       Given I have azurerm_resource_group defined
       When its name is defined
       Then it must match the "^rg-[a-zA-Z0-9]+$" regex
   ```

---

### Step 4: Generate a Terraform Plan

Run a Terraform plan and save the output to a file. This plan file will be used by `terraform-compliance` to check for compliance.

```bash
terraform init
terraform plan -out=tfplan
```

Convert the binary plan file to JSON format, which is required by `terraform-compliance`:

```bash
terraform show -json tfplan > tfplan.json
```

---

### Step 5: Run `terraform-compliance` with the Plan

Execute `terraform-compliance` to check your Terraform plan against the compliance rules you defined.

```bash
terraform-compliance -p tfplan.json -f features/
```

### Step 6: Interpret the Results

After running `terraform-compliance`, you’ll receive output indicating whether each scenario passed or failed. If a test fails, review the output to understand which specific resources or configurations need adjustments to meet compliance.

---

### Step 7: Automate in a CI/CD Pipeline (Optional)

To enforce compliance during deployment, integrate `terraform-compliance` into your CI/CD pipeline. For example, in GitHub Actions:

```yaml
name: Terraform Compliance Check

on:
  pull_request:
    branches:
      - main

jobs:
  terraform-compliance:
    runs-on: ubuntu-latest
    steps:
      - name: Check out the code
        uses: actions/checkout@v2

      - name: Set up Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.x'

      - name: Install terraform-compliance
        run: pip install terraform-compliance

      - name: Terraform Init
        run: terraform init

      - name: Terraform Plan
        run: terraform plan -out=tfplan

      - name: Show Plan in JSON
        run: terraform show -json tfplan > tfplan.json

      - name: Run terraform-compliance
        run: terraform-compliance -p tfplan.json -f features/
```

---

### Summary

This step-by-step guide gives you a process to enforce compliance on Azure resources managed by Terraform. You’ve set up:

1. **Compliance rules** for AKS clusters, Storage Accounts, and general Azure resources.
2. **Automated checks** using `terraform-compliance`.
3. **Integration with CI/CD** to automate these checks for future deployments. 

These tests help ensure your infrastructure meets best practices and security standards consistently.

Here are additional compliance scenarios for Azure resources that will help expand your coverage. These include policies for ensuring security, cost management, and operational best practices across virtual machines, databases, network security groups, and managed identities. 

---

### Use Case 4: Virtual Machines - Enforce Disk Encryption and VM Size Restrictions

Verify that all Azure Virtual Machines (VMs) have OS disk encryption enabled and are created with approved VM sizes to control costs.

1. Create a new feature file, `vm_compliance.feature`.
2. Add the following scenarios:

   ```gherkin
   Feature: Enforce compliance for Virtual Machines

     Scenario: Virtual Machines must have OS disk encryption enabled
       Given I have azurerm_virtual_machine defined
       When it contains os_disk
       Then its os_disk.encryption_settings must be true

     Scenario: Virtual Machines must be from approved VM sizes
       Given I have azurerm_virtual_machine defined
       When its vm_size is defined
       Then it must be in ["Standard_DS1_v2", "Standard_DS2_v2", "Standard_B2ms"]
   ```

These policies ensure VMs use encrypted disks and restrict VM sizes to control costs and enhance security.

---

### Use Case 5: Azure SQL Database - Enforce Threat Detection and Geo-Replication

Ensure that Azure SQL Databases have Threat Detection enabled and, where necessary, use Geo-Replication for disaster recovery.

1. Create a new feature file, `sql_database_compliance.feature`.
2. Add the following scenarios:

   ```gherkin
   Feature: Enforce compliance for Azure SQL Database

     Scenario: Azure SQL Database must have Threat Detection enabled
       Given I have azurerm_mssql_database defined
       When it contains threat_detection_policy
       Then its threat_detection_policy.state must be "Enabled"

     Scenario: Azure SQL Database must have Geo-Replication enabled for Premium Tier
       Given I have azurerm_sql_database defined
       When its sku.name is "Premium"
       Then it must contain geo_replication_enabled
       And it must be true
   ```

These policies enhance security by enabling Threat Detection and ensure high availability by enforcing Geo-Replication on critical databases.

---

### Use Case 6: Network Security Groups (NSGs) - Restrict Inbound Rules

Network Security Groups should follow best practices by restricting inbound rules, especially to avoid exposing critical ports (e.g., SSH on 22 and RDP on 3389) to the internet.

1. Create a new feature file, `nsg_compliance.feature`.
2. Add the following scenarios:

   ```gherkin
   Feature: Enforce compliance for Network Security Groups

     Scenario: NSGs must not allow inbound SSH from the internet
       Given I have azurerm_network_security_group defined
       When it contains security_rule
       Then its security_rule.access must not be "Allow" for port 22
       And its security_rule.source_address_prefix must not be "0.0.0.0/0"

     Scenario: NSGs must not allow inbound RDP from the internet
       Given I have azurerm_network_security_group defined
       When it contains security_rule
       Then its security_rule.access must not be "Allow" for port 3389
       And its security_rule.source_address_prefix must not be "0.0.0.0/0"
   ```

These policies help improve security by preventing unrestricted access to SSH and RDP ports, which are commonly targeted by attackers.

---

### Use Case 7: Managed Identity - Enforce System-Assigned Identity

Ensure that certain resources (e.g., Virtual Machines, App Services) have a System-Assigned Managed Identity enabled to secure access to Azure services without credentials.

1. Create a new feature file, `managed_identity_compliance.feature`.
2. Add the following scenario:

   ```gherkin
   Feature: Enforce compliance for Managed Identity on Azure Resources

     Scenario: Virtual Machines must have System-Assigned Managed Identity enabled
       Given I have azurerm_virtual_machine defined
       When it contains identity
       Then its identity.type must be "SystemAssigned"
   
     Scenario: App Services must have System-Assigned Managed Identity enabled
       Given I have azurerm_app_service defined
       When it contains identity
       Then its identity.type must be "SystemAssigned"
   ```

These rules ensure that sensitive resources have managed identities enabled, enhancing security by avoiding embedded credentials.

---

### Use Case 8: Azure Storage Account - Enforce Secure Transfer and Minimum Tier

Ensure that all Azure Storage Accounts have secure transfer enabled and enforce that they are created with a minimum storage tier for cost efficiency.

1. Create a new feature file, `storage_account_security.feature`.
2. Add the following scenarios:

   ```gherkin
   Feature: Enforce security and cost compliance for Storage Accounts

     Scenario: Storage Accounts must have Secure Transfer enabled
       Given I have azurerm_storage_account defined
       When it contains enable_https_traffic_only
       Then it must be true

     Scenario: Storage Accounts must use Standard tier at minimum
       Given I have azurerm_storage_account defined
       When it contains account_tier
       Then it must be "Standard"
   ```

These policies help ensure secure data transfer and control costs by enforcing a minimum storage tier.

---

### Use Case 9: Key Vault - Enforce Soft Delete and Network ACLs

Azure Key Vault should have Soft Delete enabled for data protection and be restricted by Network Access Control Lists (ACLs) for improved security.

1. Create a new feature file, `key_vault_compliance.feature`.
2. Add the following scenarios:

   ```gherkin
   Feature: Enforce compliance for Azure Key Vaults

     Scenario: Key Vaults must have Soft Delete enabled
       Given I have azurerm_key_vault defined
       When it contains soft_delete_enabled
       Then it must be true

     Scenario: Key Vaults must restrict access using Network ACLs
       Given I have azurerm_key_vault defined
       When it contains network_acls
       Then its network_acls.bypass must not be "AzureServices"
       And it must contain default_action
       Then its network_acls.default_action must be "Deny"
   ```

These policies ensure that Key Vaults are secured by enabling Soft Delete for data recovery and using Network ACLs to restrict access.

---

### Use Case 10: Log Analytics - Enforce Retention Policy and Solution Requirements

Verify that Log Analytics workspaces have a minimum data retention period and specific solutions enabled for monitoring.

1. Create a new feature file, `log_analytics_compliance.feature`.
2. Add the following scenarios:

   ```gherkin
   Feature: Enforce compliance for Log Analytics Workspaces

     Scenario: Log Analytics Workspace must have a retention policy of at least 30 days
       Given I have azurerm_log_analytics_workspace defined
       When it contains retention_in_days
       Then it must be greater than 30

     Scenario: Log Analytics Workspace must have the Security solution enabled
       Given I have azurerm_log_analytics_solution defined
       When its solution_name is defined
       Then it must contain "Security"
   ```

These policies ensure that your logging and monitoring configuration retains data for adequate historical analysis and includes security-related solutions.

---

### Summary of Additional Scenarios

1. **AKS Compliance**: VM size restrictions, Managed Identity, and load balancer SKU.
2. **Virtual Machines**: Enforced disk encryption and approved VM sizes.
3. **Storage Accounts**: Enforced secure transfer, minimum tier, and encryption.
4. **Network Security Groups**: Restricted access to SSH and RDP.
5. **Managed Identity**: Enforced managed identity for VM and App Service resources.
6. **Azure SQL Database**: Enforced Threat Detection and Geo-Replication.
7. **Key Vault**: Enforced Soft Delete and Network ACLs.
8. **Log Analytics**: Enforced retention and required solutions.

These scenarios give you a comprehensive approach to enforcing Azure compliance standards with `terraform-compliance`, covering security, operational efficiency, and cost management across various services.

https://learn.microsoft.com/en-us/azure/governance/policy/

