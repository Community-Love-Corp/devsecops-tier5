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
  default = "/subscriptions/eac7dbb7-a7ec-45bc-98de-902b34a2f404/resourcegroups/MC_jaydemo-rg_jaydemo-aks_australiaeast/providers/Microsoft.ManagedIdentity/userAssignedIdentities/azurekeyvaultsecretsprovider-jaydemo-aks"
}

variable "csi_identity_client_id" {
  type = string
  default = "a506e50a-a0aa-4e1a-8c73-eec589c280a0"

}

variable "csi_identity_object_id" {
  type = string
  default = "60d54a16-dbaa-4ccf-8436-a465e259c6c5"

}
