
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
  
 # key_vault_secrets_provider {
 #   secret_rotation_enabled  = true
 #   secret_rotation_interval = "2m"
 # }
  
  lifecycle {
    ignore_changes = [
      oidc_issuer_enabled
    ]
  }
}

resource "azurerm_user_assigned_identity" "csi_identity" {
  name                = "azurekeyvaultsecretprovider-${var.prefix}-aks"
  resource_group_name = "MC_${azurerm_resource_group.rg.name}_${azurerm_kubernetes_cluster.aks.name}_${var.location}" 
  location            = var.location
}

# See keyvault.tf for access policy block added, as this key vault complains that it does not accept RBAC as below 
#resource "azurerm_role_assignment" "aks_kv_secrets" {
  # FIXED: Replace with your actual azurerm_key_vault resource name
#  scope                = azurerm_key_vault.kv.id 
#  role_definition_name = "Key Vault Secrets User"
  
  # FIXED: Standard clean lookup path for the secrets provider identity block
#  principal_id         = azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].object_id
#}

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

#resource "azurerm_virtual_machine_scale_set_extension" "assign_csi_identity" {
#  name      = "assign-csi-identity"
#  virtual_machine_scale_set_id = azurerm_kubernetes_cluster.aks.default_node_pool[0].node_pool_id
#  publisher                    = "Microsoft.ManagedIdentity"
#  type                         = "ManagedIdentityExtensionForLinux"
#  type_handler_version         = "1.0"
  
 # settings = jsonencode({
 #   userAssignedIdentities = [
 #     var.csi_identity_resource_id
 #   ]
 # })  
#}

#resource "null_resource" "disable_csi_driver" {
#  depends_on = [
#    azurerm_kubernetes_cluster.aks
#  ]

#  provisioner "local-exec" {
#    command = <<EOT
#      az aks disable-addons \
#        --addons azure-keyvault-secrets-provider \
#        --resource-group ${azurerm_resource_group.rg.name} \
#        --name ${azurerm_kubernetes_cluster.aks.name} || true
#    EOT
#  }
#}

#resource "null_resource" "enable_csi_driver" {
#  depends_on = [
#    null_resource.disable_csi_driver

#  ]

#  provisioner "local-exec" {
#    command = <<EOT
#      az aks enable-addons \
#        --addons azure-keyvault-secrets-provider \
#        --resource-group ${azurerm_resource_group.rg.name} \
#        --name ${azurerm_kubernetes_cluster.aks.name}
#    EOT
#  }
#}
