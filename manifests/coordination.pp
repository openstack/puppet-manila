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
# [*manage_backend_package*]
#   (Optional) Whether to install the backend package.
#   Defaults to true.
#
# [*package_ensure*]
#   (Optional) ensure state for package.
#   Defaults to 'present'
#
class manila::coordination (
  $backend_url                            = $facts['os_service_default'],
  Boolean $manage_backend_package         = true,
  Stdlib::Ensure::Package $package_ensure = present,
) {
  include manila::deps

  oslo::coordination { 'manila_config':
    backend_url            => $backend_url,
    manage_backend_package => $manage_backend_package,
    package_ensure         => $package_ensure,
  }

  # all coordination settings should be applied and all packages should be
  # installed before service startup
  Oslo::Coordination['manila_config'] -> Anchor['manila::service::begin']
}
