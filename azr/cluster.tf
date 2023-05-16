data "azurerm_kubernetes_service_versions" "current" {
  location = var.region
  version_prefix = "1.25"
  include_preview = false
}


resource "azurerm_kubernetes_cluster" "cluster" {
  count               = length(var.clusters)
  name                = "tap-${var.environment}-${var.clusters[count.index]}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = "tap-${var.environment}-${var.clusters[count.index]}"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version

  default_node_pool {
    name       = "default"
    vm_size    = "Standard_D8s_v3"
    node_count = 3
    os_disk_size_gb = 100
    vnet_subnet_id = azurerm_subnet.subnet.id
    zones = [ "1", "2", "3" ]
    temporary_name_for_rotation = "defaulttemp"
  }

  identity {
    type = "SystemAssigned"
  }
}
