output id {
  value       = local.id
  description = "Applied ID"
}

output project {
  value       = local.project
  description = "Normalized project name"
}

output name {
  value       = local.name
  description = "Normalized name"
}

output environment {
  value       = local.environment
  description = "User-provided environment"
}

output attributes {
  value       = local.attributes
  description = "User-provided attributes"
}

output tags {
  value       = local.tags
  description = "Normalized Tag map"
}

output id_labels {
  value = local.id_labels
}
