resource "random_integer" "rnd" {
  min = 10000
  max = 99999
}

resource "azurerm_container_registry" "acr" {
  name                = "tapregistry${random_integer.rnd.result}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false
}

resource "azurerm_container_registry_scope_map" "map" {
  name                    = "scope-map"
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = data.azurerm_resource_group.rg.name
  actions = [
    "repositories/tap-packages/content/read",
    "repositories/tap-packages/content/write",
    "repositories/cluster-essentials-bundle/content/read",
    "repositories/cluster-essentials-bundle/content/write",
    "repositories/buildservice/content/read",
    "repositories/buildservice/content/write",
    "repositories/workloads/content/read",
    "repositories/workloads/content/write"
  ]
}


resource "azurerm_container_registry_token" "token" {
  name                    = "admin"
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = data.azurerm_resource_group.rg.name
  scope_map_id            = azurerm_container_registry_scope_map.map.id
}

resource "azurerm_container_registry_token_password" "pass" {
  container_registry_token_id = azurerm_container_registry_token.token.id

  password1 {}
  password2 {}
}

output "registry_host" {
  value = azurerm_container_registry.acr.login_server
}

output "registry_username" {
  value = azurerm_container_registry_token.token.name
}

output "registry_password" {
  value = azurerm_container_registry_token_password.pass.password1[0].value
  sensitive = true
}
