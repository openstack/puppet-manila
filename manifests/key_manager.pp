# == Class: manila::key_manager
#
# Setup and configure Key Manager options
#
# === Parameters
#
# [*backend*]
#   (Optional) Specify the key manager implementation.
#   Defaults to $facts['os_service_default']
#
class manila::key_manager (
  $backend = $facts['os_service_default'],
) {
  include manila::deps

  oslo::key_manager { 'manila_config':
    backend => $backend,
  }
}
