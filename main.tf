# Provides configuration details for Terraform
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.31.1"
    }
    databricks = {
      source  = "databrickslabs/databricks"
      version = "~> 0.5.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Configure databricks provider
provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.myworkspace.id
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-resources"
  location = "uksouth"
  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
  }
}

# Create a Databricks workspace
resource "azurerm_databricks_workspace" "myworkspace" {
  name                = "${var.prefix}-workspace"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "standard"
  tags = {
    environment = var.environment
    source      = "Terraform"
    owner       = var.owner
  }
}

resource "databricks_cluster" "shared_autoscaling" {
  cluster_name            = "${var.prefix}-Autoscaling-Cluster"
  spark_version           = var.spark_version
  node_type_id            = var.node_type_id
  autotermination_minutes = 30
  autoscale {
    min_workers = var.min_workers
    max_workers = var.max_workers
  }
  spark_conf = {
    "spark.databricks.delta.preview.enabled" = "true"
  }
  custom_tags = {
    "Owner"      = "Ola"
    "Department" = "Data Science"
  }
}

resource "databricks_notebook" "notebook" {
  content_base64 = base64encode("print('Notebook created by Terraform')")
  path      = var.notebook_path
  language  = "PYTHON"
}

resource "databricks_job" "myjob" {
  name                = "${var.prefix}-Featurization-Job"
  timeout_seconds     = 3600
  existing_cluster_id = databricks_cluster.shared_autoscaling.id
  notebook_task {
    notebook_path = var.notebook_path
  }
  max_retries         = 1
  max_concurrent_runs = 1
  email_notifications {
    no_alert_for_skipped_runs = true
  }
}