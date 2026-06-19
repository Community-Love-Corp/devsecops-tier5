resource "azurerm_key_vault" "kv" {
  name                       = "${var.prefix}-kv"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
}



resource "azurerm_key_vault_access_policy" "aks_secrets_provider" {
  # References your Key Vault resource block
  key_vault_id = azurerm_key_vault.kv.id 
  tenant_id    = "4c475f22-5bbf-43c6-833d-810e9335ade4"
  
  # Targets the exact Object ID requested by the error log
#  object_id    = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].object_id
#  object_id    = "a926f8d7-44c9-461b-9fb5-6c208a07b2b3"
  object_id    = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  # Grants the explicit actions needed to mount the files
  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_key_vault_access_policy" "terraform_runner" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  
  # Automatically resolves to your OID: 89cd58e8-2d49-4963-9664-6d3958727445
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Purge"
  ]
}

resource "azurerm_key_vault_secret" "mysecret" {
  name         = "mysecret"               # Must match objectName in your secret-provider-class.yaml
  value        = "your-super-secret-value" # Replace with your actual database string or configuration password
  key_vault_id = azurerm_key_vault.kv.id  # References your Key Vault resource block
}

data "azurerm_client_config" "current" {}