module "resource_group" {
  source       = "./modules/resource_group"
  env          = var.env
  project_name = var.project_name
  location     = var.location
}


module "azure_static_web_app" {
  source       = "./modules/azure_static_web_app"
  name         = "${var.project_name}-${var.env}"
  env          = var.env
  location     = var.location
  project_name = var.project_name
}

module "cosmos_db" {
  source       = "./modules/cosmos_db"
  name         = "${var.project_name}-${var.env}"
  env          = var.env
  location     = var.location
  project_name = var.project_name
  principal_id = module.function_app.identity_principal_id
}

module "function_app" {
  source                = "./modules/function_app"
  name                  = "${var.project_name}-${var.env}"
  env                   = var.env
  location              = var.location
  project_name          = var.project_name
  storage_account_name  = module.storage_account.storage_account_name
  cosmos_container_name = module.cosmos_db.container_name
  cosmos_database_name  = module.cosmos_db.database_name
  cosmos_endpoint       = module.cosmos_db.endpoint
}

module "storage_account" {
  source       = "./modules/storage_account"
  name         = "st${var.project_name}${var.env}"
  env          = var.env
  location     = var.location
  project_name = var.project_name
}

module "log_analytics" {
  source       = "./modules/log_analytics"
  name         = "${var.project_name}-${var.env}"
  env          = var.env
  project_name = var.project_name
  location     = var.location
}

