# provider "azurerm" {
#   features {}
# }

# resource "azurerm_resource_group" "default" {
#   name     = "container-registry-rg"
#   location = "East US 2"

#   tags = {
#     environment = "Production"
#   }
# }

# resource "azurerm_container_registry" "acr" {
#   name                = "kspcontainerregistry"
#   resource_group_name = azurerm_resource_group.default.name
#   location            = "East US 2"
#   sku                 = "Standard"
#   admin_enabled       = true
# }

# output "acr_login_server" {
#   value = azurerm_container_registry.acr.login_server
# }

# output "acr_admin_username" {
#   value     = azurerm_container_registry.acr.admin_username
#   sensitive = true
# }

# output "acr_admin_password" {
#   value     = azurerm_container_registry.acr.admin_password
#   sensitive = true
# }

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.96.0"
    }
  }
}

provider "azurerm" {
  features {}
}


locals {
  resource_group="app-grp"
  location="North Europe"
}


resource "azurerm_resource_group" "app_grp"{
  name=local.resource_group
  location=local.location
}

resource "azurerm_storage_account" "functionstore_089889" {
  name                     = "functionstore089889"
  resource_group_name      = azurerm_resource_group.app_grp.name
  location                 = azurerm_resource_group.app_grp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "function_app_plan" {
  name                = "function-app-plan"
  location            = azurerm_resource_group.app_grp.location
  resource_group_name = azurerm_resource_group.app_grp.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "functionapp_1234000" {
  name                       = "functionapp1234000"
  location                   = azurerm_resource_group.app_grp.location
  resource_group_name        = azurerm_resource_group.app_grp.name
  app_service_plan_id        = azurerm_app_service_plan.function_app_plan.id
  storage_account_name       = azurerm_storage_account.functionstore_089889.name
  storage_account_access_key = azurerm_storage_account.functionstore_089889.primary_access_key
  site_config {
    dotnet_framework_version = "v6.0"
  }
}