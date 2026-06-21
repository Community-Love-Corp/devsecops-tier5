terraform {
  required_version = ">=1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }


  backend "azurerm" {
    resource_group_name   = "msdocs-core-sql"
    storage_account_name  = "memories123"
    container_name        = "tfstate"
    key                   = "aks.terraform.tfstate"
  }
}
provider "azurerm" {
  features {
    # Key Vault: Purge all items and block vault recovery
    key_vault {
      purge_soft_delete_on_destroy                     = true
      recover_soft_deleted_key_vaults                  = true
    }
}


