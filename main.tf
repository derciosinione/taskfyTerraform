terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  #   cloud {
  #     organization = "KiariCode"
  #     workspaces {
  #       name = "learn-terraform-azure"
  #     }
  #   }
  #   required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

variable "resource_group_name" {
  default = "Taskify"
}

variable "app_name" {
  default = "taskify-app"
}

variable "location" {
  default = "francecentral"
}

variable "environment" {
  default = "Taskify Demo"
}

variable "team" {
  default = "DevOps"
}

resource "azurerm_resource_group" "group" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    Team        = var.team
  }
}


resource "azurerm_service_plan" "plan" {
  name                = "${var.app_name}-service-plan"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
  os_type             = "Linux"
  sku_name            = "B1"

  tags = {
    Environment = var.environment
    Team        = var.team
  }
}


resource "azurerm_linux_web_app" "app" {
  name                = var.app_name
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name
  service_plan_id     = azurerm_service_plan.plan.id

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "NODE_VERSION"                        = "22"
    "SCM_DO_BUILD_DURING_DEPLOYMENT"      = "true"
    "NEXT_TELEMETRY_DISABLED"             = "1"
    "NODE_ENV"                            = "production"
  }

  site_config {
    # linux_fx_version = "NODE|20-lts"
    always_on = true # Must be false for F1 tier

    application_stack {
      node_version = "20-lts"
    }

    app_command_line = "node server.js" # Add your startup command here

    health_check_path                 = "/health"
    health_check_eviction_time_in_min = 10

    http2_enabled       = true
    minimum_tls_version = "1.2"
  }

  tags = {
    Environment = var.environment
    Team        = var.team
  }
}
