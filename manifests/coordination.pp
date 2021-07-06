# == Class: manila::coordination
#
# Setup and configure Manila coordination settings.
#
# === Parameters
#
# [*backend_url*]
#   (Optional) Coordination backend URL.
#   Defaults to $::os_service_default
#
class manila::coordination (
  $backend_url = $::os_service_default,
) {

  include manila::deps

  oslo::coordination{ 'manila_config':
    backend_url => $backend_url
  }
}
