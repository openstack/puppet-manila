# == Class: manila::backends
#
# Class to set the enabled_backends list
#
# === Parameters
#
# [*enabled_backends*]
#   (required) a list of ini sections to enable.
#     This should contain names used in ceph::backend::* resources.
#     Example: ['share1', 'share2', 'sata3']
#
# Author: Andrew Woodward <awoodward@mirantis.com>
class manila::backends (
  $enabled_backends    = undef,
  # DEPRECATED
  $default_share_type = false
  ){

  # Maybe this could be extented to dynamicly find the enabled names
  manila_config {
    'DEFAULT/enabled_backends': value => join($enabled_backends, ',');
  }

  if $default_share_type {
    fail('The default_share_type parameter is deprecated in this class, you should declare it in manila::api.')
  }

}
