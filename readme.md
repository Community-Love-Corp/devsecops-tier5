Versions

0.1 Kali Linux

Wednesday 17 June 2026 14:52: Eclipse setup. First draft for day 1.  

0.2 Kali Linux

Wednesday 17 June 2026 18:00: 

Day 1 complete- Terraform used successfully to setup aks infrastructure, and to destroy. See c:/users/moose/documents/Job Apps/Victoria Uni Technical Specialist/Bridge.doc. 

![Cost savings via cloud infrastructure destruction](./TerraformDestruction.jpg)

0.3 Kali Linux

Wednesday 17 June 2026 14:50: 

Added package.json and server.js. See See c:/users/moose/documents/Job Apps/Victoria Uni Technical Specialist/Part2Of4.doc. 

0.4 Kali Linux

Wednesday 17 June 2026 17:45: 

Successful image deployment - Step 3 completed. See See c:/users/moose/documents/Job Apps/Victoria Uni Technical Specialist/Part2Of4.doc. 

![ Successful Docker Push ](./ImageDeployment.jpg)

0.5 Kali Linux
Saturday 20 June 2026 01:55: 

![ api functional on kubernetes 1 ](./health.jpg)

![ api functional on kubernetes 2 ](./config.jpg)

![ api functional on kubernetes 1 ](./secret.jpg)

For Details,  see c:/users/moose/documents/Job Apps/Victoria Uni Technical Specialist/Part2Of4.doc. 

0.6 Kali Linux
Saturday 20 June 2026 20:34: Preparation for pushing to public Git Repo: 
a. Remove cached provider binary/plugins from tracked files, and
b. Add it and similar files to .gitignore

0.7 Kali Linux
Saturday 20 June 2026 22:00: Repo sent to Github to dev branch- See Section 'Pre-req' in c:/users/moose/documents/Job Apps/Victoria Uni Technical Specialist/Part3Of4.doc. 

0.8 Kali Linux

Sunday 21 June 2026 14:00: 

Code added to enable CI/CD. See 'c:/users/moose/documents/Job Apps/Victoria Uni Technical Specialist/Part3Of4.doc'. 

0.9 Kali Linux

Sunday 21 June 2026 15:59: 

Simplified cicd code inorder to solve errors, added gates via environments in pipeline and gave some elevated permissions to terraform runner object in Azure. See Section 'Step 9 - Troubleshooting' in 'c:/users/moose/documents/Job Apps/Victoria Uni Technical Specialist/Part3Of4.doc'. 

0.10 Kali Linux

Sunday 21 June 2026 16:39: 

Idempotency issues existed because tfstate file is in .gitignore. Hence a cloud resource created to hold such information, in order to re-enable idempotency. In particular, backend added in terraform/providers.tf. For details, see Section 'Step 9 - Troubleshooting' in 'c:/users/moose/documents/Job Apps/Victoria Uni Technical Specialist/Part3Of4.doc'. 

0.11 Kali Linux

Sunday 21 June 2026 19:37: 

Added ability to recover soft-deleted secrets in key-vault to the terraform runner, due to Key Vault Access Policy current setup. For details, see Section 'Step 9 - Troubleshooting' in 'c:/users/moose/documents/Job Apps/Victoria Uni Technical Specialist/Part3Of4.doc'. 


0.12 Kali Linux

Sunday 21 June 2026 20:18: 

Updated providers.tf to ignore soft deleted resources, when creating resources, in order to prevent recovery as that interferes with idempotency. For details, see Section 'Step 9 - Troubleshooting' in 'c:/users/moose/documents/Job Apps/Victoria Uni Technical Specialist/Part3Of4.doc'. 

0.13 Kali Linux

Sunday 21 June 2026 20:52: 

Versin 0.12 failed as keyvault because even though terraform does not try to recover the keyvault, it still notices the name of the old key vault in the recycle bin and refuses to recreate it. Hence, the name of the keyvault has been updated this time. For details, see Section 'Step 9 - Troubleshooting' in 'c:/users/moose/documents/Job Apps/Victoria Uni Technical Specialist/Part3Of4.doc'. 

0.14 Kali Linux

Sunday 21 June 2026 21:21: 

The azure/login action had to added to all the downstream jobs in the cicd.yaml pipeline, so the terraform runner can authenticate with the cluster API. Similar other minor changes implemented. For details, see Section 'Step 9 - Troubleshooting' in 'c:/users/moose/documents/Job Apps/Victoria Uni Technical Specialist/Part3Of4.doc'. 

0.15 Kali Linux

Sunday 21 June 2026 21:37: 

Idempotency fix to infrastructure job in cicd.yml. It involved setting up .tfstate file in storage account during Terraform init. For details, see Section 'Step 9 - Troubleshooting' in 'c:/users/moose/documents/Job Apps/Victoria Uni Technical Specialist/Part3Of4.doc'. 


0.16 Kali Linux

Sunday 21 June 2026 23:46: 

Added RBAC to enable the cluster to access the key vault, to access secret. This is required because right now in cicd pipeline, the secret is unable to be retrieved using access policy setup. See keyvault.tf. For details, see Section 'Step 9 - Troubleshooting' in 'c:/users/moose/documents/Job Apps/Victoria Uni Technical Specialist/Part3Of4.doc'. 

0.17 Kali Linux

Sunday 22 June 2026 00:54: 

![ Pipeline for AKS App deployment](./cicd.jpg)

However app not functional because of error on cmd 'kubectl describe pod jaydemo-api-xxx..':

```
ManagedIdentityCredential authentication failed.
the requested identity isn't assigned to this resource.
Identity not found.
```

0.18 Kali Linux

Monday 22 June 2026 16:07: 

Updated keyvault.tf, to use kubelet identity to access keyvault:

```terraform
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                       = "${var.prefix}-kv-v2"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7

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
    object_id = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id

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

```
Hotfix #2: 

Monday 22 June 2026 16:25 

The CICD pipeline experienced a race condition trying to update both the key vault and aks cluster parallely after change above. Hence added following snippet after keyvault creation and before applying access policies:

```
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
```

Hotfix #3: 

Monday 22 June 2026 17:00

Turns out that key vault needs CSI driver to be installed. Presently, MS does not expose that addon to the provider to enable via terraform, hence a null_resource has been added to aks.tf, in order to remain committed to IaC paradigm. Futher, Update/Creation of key vault is made dependant on running of that code snipped. 


Hotfix #4: 

Monday 22 June 2026 17:14

Added another null_resource to first disable the driver, and then reenable it because terraform was saying that the resource is already enabled.