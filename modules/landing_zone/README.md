# landing_zone module

Reusable Azure landing-zone module for baseline infrastructure and governance.

## What it creates
- Resource Group
- Virtual Network
- Subnets
- Network Security Groups
- Private DNS Zones and VNet links
- Policy Assignments
- Optional Log Analytics workspace

## Example usage

```hcl
module "landing_zone" {
  source = "../modules/landing_zone"

  prefix                = "lz"
  location              = "northeurope"
  resource_group_name   = "lz-baseline-rg"
  create_resource_group = true

  address_space = ["10.10.0.0/16"]

  subnets = [
    {
      name              = "platform"
      prefix            = "10.10.1.0/24"
      nsg_name          = "platform-nsg"
      service_endpoints = ["Microsoft.Storage"]
    },
    {
      name     = "workload"
      prefix   = "10.10.2.0/24"
      nsg_name = "workload-nsg"
    }
  ]

  nsgs = [
    {
      name = "platform-nsg"
      security_rules = [
        {
          name                       = "AllowAzureLoadBalancerInbound"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "AzureLoadBalancer"
          destination_address_prefix = "*"
        }
      ]
    }
  ]

  private_dns_zones = ["privatelink.blob.core.windows.net"]
  enable_log_analytics = true
}
```

## Inputs
- `prefix` - resource naming prefix
- `location` - Azure region
- `create_resource_group` - whether to create the RG
- `resource_group_name` - RG name
- `resource_group_id` - existing RG id when no RG is created
- `tags` - default tags
- `vnet_name` - VNet name
- `address_space` - VNet CIDR blocks
- `subnets` - list of subnets and optional NSG/service endpoints/delegations
- `nsgs` - list of NSGs and security rules
- `private_dns_zones` - private DNS zones to create and link
- `policy_assignments` - governance assignments
- `enable_log_analytics` - create a Log Analytics workspace
- `log_analytics_workspace_name` - workspace name
- `log_analytics_sku` - workspace SKU
- `log_analytics_retention_in_days` - retention days

## Outputs
- `resource_group_id`
- `resource_group_name`
- `virtual_network_id`
- `subnet_ids`
- `network_security_group_ids`
- `private_dns_zone_ids`
- `policy_assignment_ids`
- `log_analytics_workspace_id`
