//SHARED VARIABLES
variable "product" {
  type = "string"
  description = "The name of your application"
  default = "ccd"
}

variable "env" {
  type = "string"
  description = "The deployment environment (sandbox, aat, prod etc..)"
}

variable "subscription" {
  type = "string"
}

variable "ilbIp" {
  type = "string"
}

variable "location" {
  type    = "string"
  description = "The location where you would like to deploy your infrastructure"
  default = "UK South"
}

variable "tenant_id" {
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. This is usually sourced from environment variables and not normally required to be specified."
}

variable "jenkins_AAD_objectId" {
  description = "(Required) The Azure AD object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies."
}


// ASP Specific Variables
variable "asp_capacity" {
  type    = "string"
  default = "2"
}


variable "application_type" {
  type = "string"
  default = "Web"
  description = "Type of Application Insights (Web/Other)"
}


// TAG SPECIFIC VARIABLES
variable "common_tags" {
  type = "map"
}

variable "team_contact" {
  type        = "string"
  description = "The name of your Slack channel people can use to contact your team about your infrastructure"
  default     = "#ccd-devops"
}

variable "destroy_me" {
  type        = "string"
  description = "Here be dragons! In the future if this is set to Yes then automation will delete this resource on a schedule. Please set to No unless you know what you are doing"
  default     = "No"
}

variable "external_cert_name" {
  type = "string"
}

variable "external_hostname_gateway" {
  type = "string"
}

variable "external_hostname_www" {
  type = "string"
}

// http parameters
variable "documents_timeout" {
  default = "150"
}

variable "health_check_interval" {
  default = "30"
}

variable "health_check_timeout" {
  default = "30"
}

variable "unhealthy_threshold" {
  default = "5"
}

variable "managed_identity_object_id" {
  default = ""
}

variable "file_upload_limit" {
  default = "500"
}