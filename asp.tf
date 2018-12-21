module "appServicePlan" {
  source = "git@github.com:hmcts/cnp-module-app-service-plan?ref=master"
  location = "${var.location}"
  env = "${var.env}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  asp_capacity = "${var.asp_capacity}"
  asp_name = "${var.product}"
  ase_name = "${local.ase_name}"
  tag_list = "${local.common_tags}"
}
