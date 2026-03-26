

resource "azurerm_service_plan" "plan" {
  location            = var.location
  name                = "service-plan-${var.project_name}-${var.env}"
  os_type             = "Linux"
  resource_group_name = "rg-${var.project_name}-${var.env}"
  sku_name            = "B1"
}

resource "azurerm_linux_function_app" "app" {
  location             = var.location
  name                 = "function-app-${var.project_name}-${var.env}"
  resource_group_name  = "rg-${var.project_name}-${var.env}"
  service_plan_id      = azurerm_service_plan.plan.id
  storage_account_name = var.storage_account_name

  site_config {
    application_stack {
      python_version = "3.11"
    }
  }
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY        = azurerm_application_insights.appi.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.appi.connection_string
    FUNCTIONS_WORKER_RUNTIME              = "python"
    COSMOS_ENDPOINT                       = var.cosmos_endpoint
    COSMOS_DATABASE_NAME                  = var.cosmos_database_name
    COSMOS_CONTAINER_NAME                 = var.cosmos_container_name
    FUNCTIONS_EXTENSION_VERSION           = "~4"
    SCM_DO_BUILD_DURING_DEPLOYMENT        = "true"
  }
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_application_insights" "appi" {
  application_type    = "web"
  location            = var.location
  name                = "appi-${var.project_name}-${var.env}"
  resource_group_name = "rg-${var.project_name}-${var.env}"
}
