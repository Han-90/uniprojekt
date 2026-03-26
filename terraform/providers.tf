terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.65.0"
    }
  }
  required_version = "1.14.4" # nur minor changes, keine breaking changes Version 1.15.0 wäre nicht mehr kompatibel
}
provider "azurerm" {
  features {
  }
}
