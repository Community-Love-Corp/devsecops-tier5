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
  default = "null"
}

variable "csi_identity_client_id" {
  type = string
  default = "null"

}

variable "csi_identity_object_id" {
  type = string
  default = "null"

}
