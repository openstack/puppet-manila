# == Class: manila::coordination
#
# Setup and configure Manila coordination settings.
#
# === Parameters
#
# [*backend_url*]
#   (Optional) Coordination backend URL.
#   Defaults to $facts['os_service_default']
#
class manila::coordination (
  $backend_url = $facts['os_service_default'],
) {

  include manila::deps

  oslo::coordination{ 'manila_config':
    backend_url => $backend_url
  }

  # all coordination settings should be applied and all packages should be
  # installed before service startup
  Oslo::Coordination['manila_config'] -> Anchor['manila::service::begin']
}
