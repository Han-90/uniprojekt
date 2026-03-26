resource "azurerm_log_analytics_workspace" "log" {
  location            = var.location
  name                = var.name
  resource_group_name = "rg-${var.project_name}-${var.env}"
}