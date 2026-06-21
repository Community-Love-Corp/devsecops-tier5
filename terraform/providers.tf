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
      purge_soft_deleted_hardware_security_modules_on_destroy = true
      purge_soft_deleted_keys_on_destroy                     = true
      purge_soft_deleted_secrets_on_destroy                  = true
      purge_soft_deleted_certificates_on_destroy             = true
      recover_soft_deleted_key_vaults                        = false
    }

    # API Management: Block recovery of soft-deleted instances
    api_management {
      recover_soft_deleted = false
    }

    # Cognitive Services: Block recovery of soft-deleted accounts
    cognitive_account {
      purge_soft_deleted_on_destroy = true
    }

    # App Configuration: Block recovery of soft-deleted stores
    app_configuration {
      purge_soft_deleted_on_destroy = true
    }
  }
}


