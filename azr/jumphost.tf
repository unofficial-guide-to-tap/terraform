resource "azurerm_public_ip" "jumphostpip" {
  name                = "tap-${var.environment}-jumphost-pip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "jumphost-nic" {
  name                = "tap-${var.environment}-jumphost-nic"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jumphostpip.id
  }
}

resource "azurerm_linux_virtual_machine" "jumphost" {
  name                  = "tap-${var.environment}-jumphost"
  location              = data.azurerm_resource_group.rg.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [ azurerm_network_interface.jumphost-nic.id ]
  size                  = "Standard_D2s_v3"
  admin_username        = "tapadmin"
  computer_name         = "tap-${var.environment}-jumphost"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "tapadmin"
    public_key = var.jumphost_sshkey
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-kinetic"
    sku       = "22_10-gen2"
    version   = "latest"
  }

  custom_data = base64encode(file("../common/jumphost-setup.sh"))

}


data "azurerm_public_ip" "datasourceip" {
  name = "${azurerm_public_ip.jumphostpip.name}"
  resource_group_name = "${azurerm_linux_virtual_machine.jumphost.resource_group_name}"
}

output "jumphost_user" {
  value = "tapadmin"
}

output "jumphost_address" {
  value = data.azurerm_public_ip.datasourceip.ip_address
}
