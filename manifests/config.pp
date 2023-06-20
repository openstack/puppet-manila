# == Class: manila::config
#
# This class is used to manage arbitrary manila configurations.
#
# example xxx_config
#   (optional) Allow configuration of arbitrary manila configurations.
#   The value is an hash of xxx_config resources. Example:
#   { 'DEFAULT/foo' => { value => 'fooValue'},
#     'DEFAULT/bar' => { value => 'barValue'}
#   }
#
#   In yaml format, Example:
#   xxx_config:
#     DEFAULT/foo:
#       value: fooValue
#     DEFAULT/bar:
#       value: barValue
#
# === Parameters
#
# [*manila_config*]
#   (optional) Allow configuration of manila.conf configurations.
#
# [*api_paste_ini_config*]
#   (optional) Allow configuration of api-paste.ini configurations.
#
# [*manila_rootwrap_config*]
#   (optional) Allow configuration of rootwrap.conf configurations.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class manila::config (
  Hash $manila_config          = {},
  Hash $api_paste_ini_config   = {},
  Hash $manila_rootwrap_config = {},
) {

  include manila::deps

  create_resources('manila_config', $manila_config)
  create_resources('manila_api_paste_ini', $api_paste_ini_config)
  create_resources('manila_rootwrap_config', $manila_rootwrap_config)
}
