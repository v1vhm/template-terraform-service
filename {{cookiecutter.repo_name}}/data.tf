# tflint-ignore: terraform_unused_declarations
data "azurerm_resource_group" "deployment-rg" {
  name = var.resource_group
}
