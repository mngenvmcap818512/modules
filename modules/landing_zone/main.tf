locals {
  resource_group_name          = length(var.resource_group_name) > 0 ? var.resource_group_name : "${var.prefix}-rg"
  vnet_name                    = length(var.vnet_name) > 0 ? var.vnet_name : "${var.prefix}-vnet"
  log_analytics_workspace_name = length(var.log_analytics_workspace_name) > 0 ? var.log_analytics_workspace_name : "${var.prefix}-law"
  resource_group_id            = var.create_resource_group ? azurerm_resource_group.rg[0].id : var.resource_group_id
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = local.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_network_security_group" "nsg" {
  for_each = { for item in var.nsgs : item.name => item }

  name                = each.value.name
  location            = var.location
  resource_group_name = local.resource_group_name
  tags                = var.tags

  dynamic "security_rule" {
    for_each = each.value.security_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
      description                = security_rule.value.description
    }
  }
}

resource "azurerm_subnet" "subnet" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name                 = each.value.name
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.prefix]

  service_endpoints         = try(each.value.service_endpoints, [])

  dynamic "delegation" {
    for_each = try(each.value.delegations, [])
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_name
        actions = delegation.value.actions
      }
    }
  }
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  for_each = toset(var.private_dns_zones)

  name                = each.key
  resource_group_name = local.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  for_each = azurerm_private_dns_zone.private_dns_zone

  name                  = "link-${replace(each.key, ".", "-")}"
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = each.key
  virtual_network_id    = azurerm_virtual_network.vnet.id
  depends_on            = [azurerm_virtual_network.vnet]
}

resource "azurerm_log_analytics_workspace" "law" {
  count               = var.enable_log_analytics ? 1 : 0
  name                = local.log_analytics_workspace_name
  location            = var.location
  resource_group_name = local.resource_group_name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_analytics_retention_in_days
  tags                = var.tags
}
