variable "prefix" {
  description = "The prefix used for all resources in this environment"
  default     = "etl"
}

variable "owner" {
  description = "The owner of this environment"
  default     = "Ola"
}

variable "location" {
  description = "The Azure location where all resources in this example should be created"
  default     = "uksouth"
}

variable "environment" {
  description = "The environment for all resources in this example"
  default     = "dev"
}

variable "spark_version" {
  description = "The version of Spark to use for the cluster"
  default     = "7.3.x-scala2.12"
}

variable "node_type_id" {
  description = "The type of compute nodes in the cluster"
  default     = "Standard_DS3_v2"
}

variable "notebook_path" {
  description = "The path to the notebook to run"
  default     = "/python/etl_notebook"
}

variable "min_workers" {
  description = "The minimum number of workers for the cluster"
  default     = 1
}

variable "max_workers" {
  description = "The maximum number of workers for the cluster"
  default     = 4
}