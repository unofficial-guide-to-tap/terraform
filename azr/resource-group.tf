data "azurerm_resource_group" "rg" {
  name     = "tap-${var.environment}"
}
