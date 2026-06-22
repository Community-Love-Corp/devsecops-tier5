data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                       = "${var.prefix}-kv-v2"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
  
  #keyvault creation/update waits till aks cluster exists and csi driver is enabled
  depends_on = [
  azurerm_kubernetes_cluster.aks,
  null_resource.enable_csi_driver
  ]
  
  # Access for YOU (so Terraform can create secrets)
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Purge",
      "Recover"
    ]
  }

  # Access for the AKS kubelet identity (REQUIRED FOR CSI DRIVER)
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id

    # This is the correct identity for CSI secret mounts
    #object_id = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
    
    # IMPORTANT: Use the CSI addon identity
    object_id = azurerm_kubernetes_cluster.key_vault_secrets_provider[0].secret_identity[0].object_id

    secret_permissions = [
      "Get",
      "List"
    ]
  }
}

resource "azurerm_key_vault_secret" "mysecret" {
  name         = "mysecret"
  value        = "your-super-secret-value"
  key_vault_id = azurerm_key_vault.kv.id
}
