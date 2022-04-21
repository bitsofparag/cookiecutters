## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (for e.g. `<index number>` like 1 or 004). | `list(any)` | `[]` | no |
| <a name="input_createdby"></a> [createdby](#input\_createdby) | CreatedBy, eg 'terraform' | `string` | `"terraform"` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `project`, `name`, `environment` and `attributes`. | `string` | `"-"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `dev`, `stg`, `prod`). | `string` | `"dev"` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order of one or more of `name`, `project`, `environment`. | `list(any)` | <pre>[<br>  "environment",<br>  "project"<br>]</pre> | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy e.g 'MyOrg' | `string` | `"bitsofparag"` | no |
| <a name="input_name"></a> [name](#input\_name) | Unique name to identify the resource or workspace (e.g. `webserver` or `consul-cluster`). | `string` | `""` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name, preferably namespace (e.g `acme`) | `string` | `"{{cookiecutter.project_label}}"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags, for e.g. {"network" = "vpc"}. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_attributes"></a> [attributes](#output\_attributes) | User-provided attributes |
| <a name="output_environment"></a> [environment](#output\_environment) | User-provided environment |
| <a name="output_id"></a> [id](#output\_id) | Applied ID |
| <a name="output_id_labels"></a> [id\_labels](#output\_id\_labels) | n/a |
| <a name="output_name"></a> [name](#output\_name) | Normalized name |
| <a name="output_project"></a> [project](#output\_project) | Normalized project name |
| <a name="output_tags"></a> [tags](#output\_tags) | Normalized Tag map |
