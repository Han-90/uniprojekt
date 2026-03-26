resource "azurerm_cosmosdb_account" "db" {
  location            = var.location
  name                = "db-${var.project_name}-${var.env}"
  offer_type          = "Standard"
  resource_group_name = "rg-${var.project_name}-${var.env}"
  kind                = "GlobalDocumentDB"
  consistency_policy {
    consistency_level = "Session"
  }
  geo_location {
    failover_priority = 0
    location          = var.location
  }
}

resource "azurerm_cosmosdb_sql_database" "app" {
  name                = "appdb"
  resource_group_name = "rg-${var.project_name}-${var.env}"
  account_name        = azurerm_cosmosdb_account.db.name
}

resource "azurerm_cosmosdb_sql_container" "items" {
  name                  = "items"
  resource_group_name   = "rg-${var.project_name}-${var.env}"
  account_name          = azurerm_cosmosdb_account.db.name
  database_name         = azurerm_cosmosdb_sql_database.app.name
  partition_key_paths   = ["/id"]
  partition_key_version = "1"
}

data "azurerm_cosmosdb_sql_role_definition" "data_contributor" {
  account_name        = azurerm_cosmosdb_account.db.name
  resource_group_name = "rg-${var.project_name}-${var.env}"
  role_definition_id  = "00000000-0000-0000-0000-000000000002"
}

resource "azurerm_cosmosdb_sql_role_assignment" "function_access" {
  account_name        = azurerm_cosmosdb_account.db.name
  resource_group_name = "rg-${var.project_name}-${var.env}"
  role_definition_id  = data.azurerm_cosmosdb_sql_role_definition.data_contributor.id
  principal_id        = var.principal_id
  scope               = azurerm_cosmosdb_account.db.id
}

