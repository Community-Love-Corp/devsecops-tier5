
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.prefix}-dns"
  
  default_node_pool {
    name                = "nodepool1"
    node_count          = 1
    vm_size             = "Standard_B2s"
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "kubenet"
  }
  
  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }
  
  lifecycle {
    ignore_changes = [
      oidc_issuer_enabled,
      key_vault_secrets_provider
    ]
  }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  # ADD THIS LINE: Explicitly locks the GUID so it never changes or conflicts
  name                             = uuidv5("url", "https://jaydemo.azure")
  # References your existing Azure Container Registry resource ID
  scope                = azurerm_container_registry.acr.id # Change "acr" to match your actual ACR local name
  role_definition_name = "AcrPull"
  
  # FIXED: Target the Kubelet Identity block instead of the Control Plane Identity
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}

