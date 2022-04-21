locals {
  enabled = var.enabled == true ? true : false
  id_context = {
    project     = var.project
    name        = var.name
    environment = var.environment
  }

  # run loop for label order and set in all the values.
  id_labels = [for l in var.label_order : local.id_context[l] if length(local.id_context[l]) > 0]

  id          = lower(join(var.delimiter, local.id_labels, var.attributes))
  project     = local.enabled == true ? lower(format("%v", var.project)) : ""
  name        = local.enabled == true ? lower(format("%v", var.name)) : ""
  environment = local.enabled == true ? lower(format("%v", var.environment)) : ""
  createdby   = local.enabled == true ? lower(format("%v", var.createdby)) : ""
  managedby   = local.enabled == true ? lower(format("%v", var.managedby)) : ""
  attributes  = local.enabled == true ? lower(format("%v", join(var.delimiter, compact(var.attributes)))) : ""

  # Merge input tags with our tags.
  # Note: `Name` has a special meaning in AWS and we need to disambiguate it by using the computed `id`
  tags = merge(
    {
      "Name"        = local.id
      "Project"     = local.project
      "Environment" = local.environment
      "CreatedBy"   = local.createdby
      "ManagedBy"   = local.managedby
    },
    var.tags
  )
}
