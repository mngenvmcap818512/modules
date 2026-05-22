variable "prefix" {
  type        = string
  description = "Prefix used to name baseline landing zone resources."
  default     = "lz"
}

variable "location" {
  type        = string
  description = "Azure location for baseline landing zone resources."
  default     = "northeurope"
}

variable "create_resource_group" {
  type        = bool
  description = "Whether the module should create the landing zone resource group."
  default     = true
}

variable "resource_group_name" {
  type        = string
  description = "Name of the landing zone resource group. Leave blank to derive from prefix."
  default     = ""
}

variable "resource_group_id" {
  type        = string
  description = "Existing resource group ID to use when create_resource_group is false."
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all baseline resources."
  default     = {}
}

variable "vnet_name" {
  type        = string
  description = "Name of the landing zone virtual network. Leave blank to derive from prefix."
  default     = ""
}

variable "address_space" {
  type        = list(string)
  description = "Address spaces for the landing zone virtual network."
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  type = list(object({
    name              = string
    prefix            = string
    nsg_name          = optional(string)
    service_endpoints = optional(list(string), [])
    delegations = optional(list(object({
      name         = string
      service_name = string
      actions      = optional(list(string), [])
    })), [])
  }))
  description = "List of subnets to create in the landing zone VNet."
  default     = []
}

variable "nsgs" {
  type = list(object({
    name = string
    security_rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
      description                = optional(string, "")
    }))
  }))
  description = "Network security groups to create for landing zone subnets."
  default     = []
}

variable "private_dns_zones" {
  type        = list(string)
  description = "Private DNS zones to create and link to the landing zone VNet."
  default     = []
}

variable "policy_assignments" {
  type = list(object({
    name                 = string
    display_name         = string
    policy_definition_id = string
    scope                = optional(string, "")
    description          = optional(string, "")
    not_scopes           = optional(list(string), [])
    parameters           = optional(map(any), {})
  }))
  description = "Policy assignments to apply for landing zone governance."
  default     = []
}

variable "enable_log_analytics" {
  type        = bool
  description = "Whether to create a Log Analytics workspace for baseline monitoring."
  default     = false
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name of the Log Analytics workspace. Leave blank to derive from prefix."
  default     = ""
}

variable "log_analytics_sku" {
  type        = string
  description = "SKU for the Log Analytics workspace."
  default     = "PerGB2018"
}

variable "log_analytics_retention_in_days" {
  type        = number
  description = "Retention days for logs in the Log Analytics workspace."
  default     = 30
}
