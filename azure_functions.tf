variable "upload_blob_function_app_name" {
  default = "uploadtaskifyfunc"
}


variable "get_all_blobs_function_name" {
  default = "gettaskifyfunc"
}

variable "delete_blob_function_name" {
  default = "deletetaskifyfunc"
}


variable "create_task_function_name" {
  default = "createtaskprojecttaskifyfunc"
}

variable "add_project_comment_function_name" {
  default = "addcommenttaskifyfunc"
}


variable "get_all_task_function_name" {
  default = "getalltaskprojecttaskifyfunc"
}

variable "get_all_project_comment_function_name" {
  default = "getallcommenttaskifyfunc"
}


variable "function_plan_name" {
  default = "taskify-function-plan"
}


# Obter Storage existente
data "azurerm_storage_account" "storage" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

data "azurerm_cosmosdb_account" "cosmosdb" {
  name                = var.cosmos_db_account_name
  resource_group_name = var.resource_group_name
}


locals {
  function_app_settings = {
    AzureWebJobsStorage      = data.azurerm_storage_account.storage.primary_connection_string
    FUNCTIONS_WORKER_RUNTIME = "python"
    FUNCTION_PROJECT_PREFIX  = "project_"
    STORAGE_ACCOUNT_NAME     = var.storage_account_name
    STORAGE_ACCOUNT_KEY      = data.azurerm_storage_account.storage.primary_access_key
    STORAGE_CONTAINER_NAME   = var.storage_private_container_name
    STORAGE_ACCOUNT_URL      = data.azurerm_storage_account.storage.primary_blob_endpoint
  }

  function_app_for_cosmos_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
    COSMOS_URL               = data.azurerm_cosmosdb_account.cosmosdb.endpoint
    COSMOS_KEY               = data.azurerm_cosmosdb_account.cosmosdb.primary_key
    DATABASE_NAME            = data.azurerm_cosmosdb_account.cosmosdb.name
  }
}


resource "azurerm_service_plan" "function_plan" {
  name                = var.function_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "Y1" # Consumo (serverless)
}


resource "azurerm_linux_function_app" "upload_blob_function_app" {
  name                        = var.upload_blob_function_app_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  service_plan_id             = azurerm_service_plan.function_plan.id
  storage_account_name        = var.storage_account_name
  storage_account_access_key  = data.azurerm_storage_account.storage.primary_access_key
  functions_extension_version = "~4"

  site_config {
    application_stack {
      python_version = "3.11"
    }
    use_32_bit_worker = false
  }

  app_settings = local.function_app_settings

  identity {
    type = "SystemAssigned"
  }

  https_only = true
}


resource "azurerm_linux_function_app" "get_all_blob_function_app" {
  name                        = var.get_all_blobs_function_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  service_plan_id             = azurerm_service_plan.function_plan.id
  storage_account_name        = var.storage_account_name
  storage_account_access_key  = data.azurerm_storage_account.storage.primary_access_key
  functions_extension_version = "~4"

  site_config {
    application_stack {
      python_version = "3.11"
    }
    use_32_bit_worker = false
  }

  app_settings = local.function_app_settings

  identity {
    type = "SystemAssigned"
  }

  https_only = true
}

resource "azurerm_linux_function_app" "delete_blob_function_app" {
  name                        = var.delete_blob_function_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  service_plan_id             = azurerm_service_plan.function_plan.id
  storage_account_name        = var.storage_account_name
  storage_account_access_key  = data.azurerm_storage_account.storage.primary_access_key
  functions_extension_version = "~4"

  site_config {
    application_stack {
      python_version = "3.11"
    }
    use_32_bit_worker = false
  }

  app_settings = local.function_app_settings

  identity {
    type = "SystemAssigned"
  }

  https_only = true
}


resource "azurerm_linux_function_app" "create_project_function_app" {
  name                        = var.create_task_function_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  service_plan_id             = azurerm_service_plan.function_plan.id
  storage_account_name        = var.storage_account_name
  storage_account_access_key  = data.azurerm_storage_account.storage.primary_access_key
  functions_extension_version = "~4"

  site_config {
    application_stack {
      python_version = "3.11"
    }
    use_32_bit_worker = false
  }

  app_settings = local.function_app_for_cosmos_settings

  identity {
    type = "SystemAssigned"
  }

  https_only = true
}

resource "azurerm_linux_function_app" "add_comment_project_function_app" {
  name                       = var.add_project_comment_function_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.function_plan.id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = data.azurerm_storage_account.storage.primary_access_key

  functions_extension_version = "~4"

  site_config {
    application_stack {
      python_version = "3.11"
    }
    use_32_bit_worker = false
  }

  app_settings = local.function_app_for_cosmos_settings

  identity {
    type = "SystemAssigned"
  }

  https_only = true
}

resource "azurerm_linux_function_app" "get_all_comment_project_function_app" {
  name                       = var.get_all_project_comment_function_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.function_plan.id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = data.azurerm_storage_account.storage.primary_access_key

  functions_extension_version = "~4"

  site_config {
    application_stack {
      python_version = "3.11"
    }
    use_32_bit_worker = false
  }

  app_settings = local.function_app_for_cosmos_settings

  identity {
    type = "SystemAssigned"
  }

  https_only = true
}



resource "azurerm_linux_function_app" "get_all_task_project_function_app" {
  name                       = var.get_all_task_function_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = azurerm_service_plan.function_plan.id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = data.azurerm_storage_account.storage.primary_access_key

  functions_extension_version = "~4"

  site_config {
    application_stack {
      python_version = "3.11"
    }
    use_32_bit_worker = false
  }

  app_settings = local.function_app_for_cosmos_settings

  identity {
    type = "SystemAssigned"
  }

  https_only = true
}

