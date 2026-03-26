output "endpoint" {
  value = azurerm_cosmosdb_account.db.endpoint
}

output "database_name" {
  value = azurerm_cosmosdb_sql_database.app.name
}

output "container_name" {
  value = azurerm_cosmosdb_sql_container.items.name
}
