provider "azurerm" {
  features {}
  skip_provider_registration = true
}


locals {
  resource_group="app-grp"
  location="North Europe"
}


resource "azurerm_resource_group" "app_grp"{
  name=local.resource_group
  location=local.location
}

resource "azurerm_storage_account" "functionstore230108" {
  name                     = "functionstore230108"
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

resource "azurerm_function_app" "functionapp20230108" {
  name                       = "functionapp20230108"
  location                   = azurerm_resource_group.app_grp.location
  resource_group_name        = azurerm_resource_group.app_grp.name
  app_service_plan_id        = azurerm_app_service_plan.function_app_plan.id
  storage_account_name       = azurerm_storage_account.functionstore230108.name
  storage_account_access_key = azurerm_storage_account.functionstore230108.primary_access_key
  site_config {
    dotnet_framework_version = "v6.0"
  }
}
