output "resource_group_id" {
  value       = local.resource_group_id
  description = "ID of the landing zone resource group."
}

output "resource_group_name" {
  value       = local.resource_group_name
  description = "Name of the landing zone resource group."
}

output "virtual_network_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "ID of the landing zone virtual network."
}

output "subnet_ids" {
  value       = { for s in azurerm_subnet.subnet : s.name => s.id }
  description = "IDs of the landing zone subnets."
}

output "network_security_group_ids" {
  value       = { for n in azurerm_network_security_group.nsg : n.name => n.id }
  description = "IDs of the landing zone network security groups."
}

output "private_dns_zone_ids" {
  value       = { for z in azurerm_private_dns_zone.private_dns_zone : z.name => z.id }
  description = "IDs of the landing zone private DNS zones."
}

output "policy_assignment_ids" {
  value       = { for p in azurerm_policy_assignment.policy : p.name => p.id }
  description = "IDs of the landing zone policy assignments."
}

output "log_analytics_workspace_id" {
  value       = try(azurerm_log_analytics_workspace.law[0].id, "")
  description = "ID of the created Log Analytics workspace, if enabled."
}
