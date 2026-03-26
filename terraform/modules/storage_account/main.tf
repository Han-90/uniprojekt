resource "azurerm_storage_account" "st" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = var.location
  name                     = "st${var.project_name}${var.env}"
  resource_group_name      = "rg-${var.project_name}-${var.env}"
}
