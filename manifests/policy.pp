# == Class: manila::policy
#
# Configure the manila policies
#
# === Parameters
#
# [*policies*]
#   (Optional) Set of policies to configure for manila
#   Example :
#     {
#       'manila-context_is_admin' => {
#         'key' => 'context_is_admin',
#         'value' => 'true'
#       },
#       'manila-default' => {
#         'key' => 'default',
#         'value' => 'rule:admin_or_owner'
#       }
#     }
#   Defaults to empty hash.
#
# [*policy_path*]
#   (Optional) Path to the manila policy.yaml file
#   Defaults to /etc/manila/policy.yaml
#
class manila::policy (
  $policies    = {},
  $policy_path = '/etc/manila/policy.yaml',
) {

  include manila::deps
  include manila::params

  validate_legacy(Hash, 'validate_hash', $policies)

  Openstacklib::Policy::Base {
    file_path   => $policy_path,
    file_user   => 'root',
    file_group  => $::manila::params::group,
    file_format => 'yaml',
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'manila_config': policy_file => $policy_path }

}
