# == Class: manila::policy
#
# Configure the manila policies
#
# === Parameters
#
# [*policies*]
#   (optional) Set of policies to configure for manila
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
#   (optional) Path to the manila policy.json file
#   Defaults to /etc/manila/policy.json
#
class manila::policy (
  $policies    = {},
  $policy_path = '/etc/manila/policy.json',
) {

  include ::manila::deps
  include ::manila::params

  validate_hash($policies)

  Openstacklib::Policy::Base {
    file_path  => $policy_path,
    file_user  => 'root',
    file_group => $::manila::params::group,
  }

  create_resources('openstacklib::policy::base', $policies)

  oslo::policy { 'manila_config': policy_file => $policy_path }

}
