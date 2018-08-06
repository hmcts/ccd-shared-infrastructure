module "shared-vault" {
  source = "git@github.com:hmcts/cnp-module-key-vault.git?ref=master"
  name = "ccd-shared-${var.env}"
  product = "${var.product}"
  env = "${var.env}"
  tenant_id = "${var.tenant_id}"
  object_id = "${var.jenkins_AAD_objectId}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  product_group_object_id = "be8b3850-998a-4a66-8578-da268b8abd6b"
}

output "key_vault_name" {
  value = "${module.shared-vault.key_vault_name}"
}

output "key_vault_uri" {
  value = "${module.shared-vault.key_vault_uri}"
}
