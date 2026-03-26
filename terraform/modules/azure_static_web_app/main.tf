resource "azurerm_static_web_app" "example" {
  name                = "${var.project_name}-${var.env}"
  resource_group_name = "rg-${var.project_name}-${var.env}"
  location            = var.location
}
