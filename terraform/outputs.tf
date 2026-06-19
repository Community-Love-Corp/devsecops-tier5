output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "aks_kubelet_client_id" {
  value       = azurerm_kubernetes_cluster.aks.kubelet_identity[0].client_id
  description = "The auto-generated Client ID of the AKS Kubelet identity."
}