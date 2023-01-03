# Google Service Account Module

This module allows simplified creation and management of one a service account and its IAM bindings. A key can optionally be generated and will be stored in Terraform state. To use it create a sensitive output in your root modules referencing the `key` output, then extract the private key from the JSON formatted outputs. Alternatively, the `key` can be generated with `openssl` library and only public part uploaded to the Service Account, for more refer to the [Onprem SA Key Management](../../blueprints/cloud-operations/onprem-sa-key-management/) example.

Note that this module does not fully comply with our design principles, as outputs have no dependencies on IAM bindings to prevent resource cycles.

## Example

```hcl
module "myproject-default-service-accounts" {
  source            = "./fabric/modules/iam-service-account"
  project_id        = "myproject"
  name              = "vm-default"
  generate_key      = true
  # authoritative roles granted *on* the service accounts to other identities
  iam       = {
    "roles/iam.serviceAccountUser" = ["user:foo@example.com"]
  }
  # non-authoritative roles granted *to* the service accounts on other resources
  iam_project_roles = {
    "myproject" = [
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter",
    ]
  }
}
# tftest modules=1 resources=5
```
<!-- TFDOC OPTS files:1 -->
<!-- BEGIN TFDOC -->

## Files

| name | description | resources |
|---|---|---|
| [iam.tf](./iam.tf) | IAM bindings. | <code>google_billing_account_iam_member</code> · <code>google_folder_iam_member</code> · <code>google_organization_iam_member</code> · <code>google_project_iam_member</code> · <code>google_service_account_iam_binding</code> · <code>google_service_account_iam_member</code> · <code>google_storage_bucket_iam_member</code> |
| [main.tf](./main.tf) | Module-level locals and resources. | <code>google_service_account</code> · <code>google_service_account_key</code> |
| [outputs.tf](./outputs.tf) | Module outputs. |  |
| [variables.tf](./variables.tf) | Module variables. |  |
| [versions.tf](./versions.tf) | Version pins. |  |

## Variables

| name | description | type | required | default |
|---|---|:---:|:---:|:---:|
| [name](variables.tf#L91) | Name of the service account to create. | <code>string</code> | ✓ |  |
| [project_id](variables.tf#L106) | Project id where service account will be created. | <code>string</code> | ✓ |  |
| [description](variables.tf#L17) | Optional description. | <code>string</code> |  | <code>null</code> |
| [display_name](variables.tf#L23) | Display name of the service account to create. | <code>string</code> |  | <code>&#34;Terraform-managed.&#34;</code> |
| [generate_key](variables.tf#L29) | Generate a key for service account. | <code>bool</code> |  | <code>false</code> |
| [iam](variables.tf#L35) | IAM bindings on the service account in {ROLE => [MEMBERS]} format. | <code>map&#40;list&#40;string&#41;&#41;</code> |  | <code>&#123;&#125;</code> |
| [iam_additive](variables.tf#L42) | IAM additive bindings on the service account in {ROLE => [MEMBERS]} format. | <code>map&#40;list&#40;string&#41;&#41;</code> |  | <code>&#123;&#125;</code> |
| [iam_billing_roles](variables.tf#L49) | Billing account roles granted to this service account, by billing account id. Non-authoritative. | <code>map&#40;list&#40;string&#41;&#41;</code> |  | <code>&#123;&#125;</code> |
| [iam_folder_roles](variables.tf#L56) | Folder roles granted to this service account, by folder id. Non-authoritative. | <code>map&#40;list&#40;string&#41;&#41;</code> |  | <code>&#123;&#125;</code> |
| [iam_organization_roles](variables.tf#L63) | Organization roles granted to this service account, by organization id. Non-authoritative. | <code>map&#40;list&#40;string&#41;&#41;</code> |  | <code>&#123;&#125;</code> |
| [iam_project_roles](variables.tf#L70) | Project roles granted to this service account, by project id. | <code>map&#40;list&#40;string&#41;&#41;</code> |  | <code>&#123;&#125;</code> |
| [iam_sa_roles](variables.tf#L77) | Service account roles granted to this service account, by service account name. | <code>map&#40;list&#40;string&#41;&#41;</code> |  | <code>&#123;&#125;</code> |
| [iam_storage_roles](variables.tf#L84) | Storage roles granted to this service account, by bucket name. | <code>map&#40;list&#40;string&#41;&#41;</code> |  | <code>&#123;&#125;</code> |
| [prefix](variables.tf#L96) | Prefix applied to service account names. | <code>string</code> |  | <code>null</code> |
| [public_keys_directory](variables.tf#L111) | Path to public keys data files to upload to the service account (should have `.pem` extension). | <code>string</code> |  | <code>&#34;&#34;</code> |
| [service_account_create](variables.tf#L117) | Create service account. When set to false, uses a data source to reference an existing service account. | <code>bool</code> |  | <code>true</code> |

## Outputs

| name | description | sensitive |
|---|---|:---:|
| [email](outputs.tf#L17) | Service account email. |  |
| [iam_email](outputs.tf#L25) | IAM-format service account email. |  |
| [id](outputs.tf#L33) | Service account id. |  |
| [key](outputs.tf#L42) | Service account key. | ✓ |
| [name](outputs.tf#L48) | Service account name. |  |
| [service_account](outputs.tf#L57) | Service account resource. |  |
| [service_account_credentials](outputs.tf#L62) | Service account json credential templates for uploaded public keys data. |  |

<!-- END TFDOC -->

<!-- BEGIN_TF_DOCS -->
## Usage

It's very easy to use!
```hcl
provider "google" {
}

resource "random_id" "service_account_name" {
  byte_length = 8
}

module "google_service_account" {
  source     = "../../"
  project_id = var.project_id
  name       = "sa-test-${random_id.service_account_name.hex}"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.1 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.40.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.40.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name of the service account to create. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project id where service account will be created. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Optional description. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the service account to create. | `string` | `"Terraform-managed."` | no |
| <a name="input_generate_key"></a> [generate\_key](#input\_generate\_key) | Generate a key for service account. | `bool` | `false` | no |
| <a name="input_group_memberships"></a> [group\_memberships](#input\_group\_memberships) | Group IDs this service account should be a member of | `list(string)` | `[]` | no |
| <a name="input_iam"></a> [iam](#input\_iam) | IAM bindings on the service account in {ROLE => [MEMBERS]} format. | `map(list(string))` | `{}` | no |
| <a name="input_iam_additive"></a> [iam\_additive](#input\_iam\_additive) | IAM additive bindings on the service account in {ROLE => [MEMBERS]} format. | `map(list(string))` | `{}` | no |
| <a name="input_iam_billing_roles"></a> [iam\_billing\_roles](#input\_iam\_billing\_roles) | Billing account roles granted to this service account, by billing account id. Non-authoritative. | `map(list(string))` | `{}` | no |
| <a name="input_iam_folder_roles"></a> [iam\_folder\_roles](#input\_iam\_folder\_roles) | Folder roles granted to this service account, by folder id. Non-authoritative. | `map(list(string))` | `{}` | no |
| <a name="input_iam_organization_roles"></a> [iam\_organization\_roles](#input\_iam\_organization\_roles) | Organization roles granted to this service account, by organization id. Non-authoritative. | `map(list(string))` | `{}` | no |
| <a name="input_iam_project_roles"></a> [iam\_project\_roles](#input\_iam\_project\_roles) | Project roles granted to this service account, by project id. | `map(list(string))` | `{}` | no |
| <a name="input_iam_sa_roles"></a> [iam\_sa\_roles](#input\_iam\_sa\_roles) | Service account roles granted to this service account, by service account name. | `map(list(string))` | `{}` | no |
| <a name="input_iam_storage_roles"></a> [iam\_storage\_roles](#input\_iam\_storage\_roles) | Storage roles granted to this service account, by bucket name. | `map(list(string))` | `{}` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix applied to service account names. | `string` | `null` | no |
| <a name="input_public_keys_directory"></a> [public\_keys\_directory](#input\_public\_keys\_directory) | Path to public keys data files to upload to the service account (should have `.pem` extension). | `string` | `""` | no |
| <a name="input_service_account_create"></a> [service\_account\_create](#input\_service\_account\_create) | Create service account. When set to false, uses a data source to reference an existing service account. | `bool` | `true` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_email"></a> [email](#output\_email) | Service account email. |
| <a name="output_iam_email"></a> [iam\_email](#output\_iam\_email) | IAM-format service account email. |
| <a name="output_id"></a> [id](#output\_id) | Service account id. |
| <a name="output_key"></a> [key](#output\_key) | Service account key. |
| <a name="output_name"></a> [name](#output\_name) | Service account name. |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | Service account resource. |
| <a name="output_service_account_credentials"></a> [service\_account\_credentials](#output\_service\_account\_credentials) | Service account json credential templates for uploaded public keys data. |

## Resource types

| Type | Used |
|------|-------|
| [google_billing_account_iam_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/billing_account_iam_member) | 1 |
| [google_cloud_identity_group_membership](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_identity_group_membership) | 1 |
| [google_folder_iam_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member) | 1 |
| [google_organization_iam_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_member) | 1 |
| [google_project_iam_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | 1 |
| [google_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | 1 |
| [google_service_account_iam_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | 1 |
| [google_service_account_iam_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | 2 |
| [google_service_account_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) | 2 |
| [google_storage_bucket_iam_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | 1 |

**`Used` only includes resource blocks.** `for_each` and `count` meta arguments, as well as resource blocks of modules are not considered.

## Modules

No modules.

## Resources by Files

### iam.tf

| Name | Type |
|------|------|
| [google_billing_account_iam_member.billing-roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/billing_account_iam_member) | resource |
| [google_cloud_identity_group_membership.group-memberships](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_identity_group_membership) | resource |
| [google_folder_iam_member.folder-roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_member) | resource |
| [google_organization_iam_member.organization-roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_member) | resource |
| [google_project_iam_member.project-roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account_iam_binding.roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [google_service_account_iam_member.additive](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_service_account_iam_member.roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [google_storage_bucket_iam_member.bucket-roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |

### main.tf

| Name | Type |
|------|------|
| [google_service_account.service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_key.key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) | resource |
| [google_service_account_key.upload_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) | resource |
| [google_service_account.service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/service_account) | data source |
<!-- END_TF_DOCS -->