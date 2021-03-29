variable "systemName" {
  default     = "playground"
  description = "unique Name of the system"
}

variable "region" {
  default     = "us-east-1"
  description = "server's region - default is N. Virginia"
}

variable "environment" {
  default     = "dev"
  description = "environment tag for different kind of purpose"
}

variable "snsExternalId" {
  default     = "snsExternal"
  description = "ExternalId for sns policy"
}
