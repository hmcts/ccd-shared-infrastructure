module "vault" {
  source = "git@github.com:hmcts/cnp-module-key-vault.git?ref=master"
  name = "ccd-${var.env}"
  product = "${var.product}"
  env = "${var.env}"
  tenant_id = "${var.tenant_id}"
  object_id = "${var.jenkins_AAD_objectId}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  product_group_object_id = "be8b3850-998a-4a66-8578-da268b8abd6b"

  common_tags = "${local.tags}"
}

output "vaultName" {
  value = "${module.vault.key_vault_name}"
}

output "vaultUri" {
  value = "${module.vault.key_vault_uri}"
}
