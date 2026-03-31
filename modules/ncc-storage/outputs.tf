output "ncc_id" {
  description = "ID of the Network Connectivity Config"
  value       = databricks_mws_network_connectivity_config.this.network_connectivity_config_id
}

output "ncc_name" {
  description = "Name of the Network Connectivity Config"
  value       = databricks_mws_network_connectivity_config.this.name
}

output "private_endpoint_rules" {
  description = "Map of created private endpoint rules"
  value       = { for k, v in databricks_mws_ncc_private_endpoint_rule.storage : k => v.rule_id }
}
