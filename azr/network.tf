resource "azurerm_virtual_network" "network" {
  name                = "tap-${var.environment}"
  address_space       = ["172.16.0.0/16"]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "tap-${var.environment}-internal"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["172.16.0.0/24"]
}
