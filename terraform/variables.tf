variable "prefix" {
  type    = string
  default = "jaydemo"
}

variable "location" {
  type    = string
  default = "australiaeast"
}

variable "csi_identity_resource_id" {
  type = string
  default =  "/subscriptions/eac7dbb7-a7ec-45bc-98de-902b34a2f404/resourcegroups/MC_jaydemo-rg_jaydemo-aks_australiaeast/providers/Microsoft.ManagedIdentity/userAssignedIdentities/azurekeyvaultsecretsprovider-jaydemo-aks"
}

variable "csi_identity_client_id" {
  type = string
  default = "2c6d4b30-5cbc-420f-8f93-dc8df1253b8b"

}

variable "csi_identity_object_id" {
  type = string
  default = "bbf72135-7bb2-46ad-b202-2e5c1747caa2"

}
