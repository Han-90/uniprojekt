output "identity_principal_id" {
  value = azurerm_linux_function_app.app.identity[0].principal_id

}
