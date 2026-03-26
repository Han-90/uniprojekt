resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "rg-${var.project_name}-${var.env}"
}