provider "azurerm" {
  # Configuration options
  version = "=2.36.0"
  subscription_id = var.subscription_id
  #tenant_id = var.tenant_id
  features {}
}