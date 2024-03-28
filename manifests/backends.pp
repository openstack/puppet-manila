# == Class: manila::backends
#
# Class to set the enabled_backends list
#
# === Parameters
#
# [*enabled_share_backends*]
#   (Required) a list of ini sections to enable.
#   This should contain names used in manila::backend::* resources.
#   Example: ['share1', 'share2', 'sata3']
#
# Author: Andrew Woodward <awoodward@mirantis.com>
class manila::backends (
  Variant[String[1], Array[String[1], 1]] $enabled_share_backends
) {

  include manila::deps

  # Maybe this could be extended to dynamically find the enabled names
  manila_config {
    'DEFAULT/enabled_share_backends': value => join(any2array($enabled_share_backends), ',');
  }

}
