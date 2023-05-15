resource "azurerm_virtual_network" "network" {
  name                = "tap-${var.environment}"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "tap-${var.environment}-internal"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.0.2.0/24"]
}

#resource "azurerm_network_interface" "interface" {
#  name                = "tap-${var.environment}-nic"
#  location            = data.azurerm_resource_group.rg.location
#  resource_group_name = data.azurerm_resource_group.rg.name
#
#  ip_configuration {
#    name                          = "internal"
#    subnet_id                     = azurerm_subnet.subnet.id
#    private_ip_address_allocation = "Dynamic"
#    public_ip_address_id          = azurerm_public_ip.pubip.id
#  }
#}
#
#resource "azurerm_public_ip" "pubip" {
#  name                = "tap-${var.environment}-jumphost-pip"
#  location            = data.azurerm_resource_group.rg.location
#  resource_group_name = data.azurerm_resource_group.rg.name
#  allocation_method   = "Dynamic"
#}

