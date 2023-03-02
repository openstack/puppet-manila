# == define: manila::backend::flashblade
#
# Configures Manila to use the Pure Storage FlashBlade share driver
# Compatible for multiple backends
#
# === Parameters
#
# [*flashblade_api*]
#   (required) API token for admin-privileged user on system.
#
# [*flashblade_mgmt_vip*]
#   (required) Management VIP for the FlashBlade.
#
# [*flashblade_data_vip*]
#   (required) Data VIP for the FlashBlade.
#
# [*share_backend_name*]
#   (optional) Name of the backend in manila.conf that
#   these settings will reside in
#
# [*backend_availability_zone*]
#   (Optional) Availability zone for this share backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $facts['os_service_default'].
#
# [*flashblade_eradicate*]
#   (optional) Fully eradicate deleted shares and snapshots.
#   Defaults to True
#
# [*package_ensure*]
#   (optional) Ensure state for package. Defaults to 'present'.
#
# === Examples
#
#  manila::backend::flashblade { 'myBackend':
#    flashblade_api                => <API token>,
#    flashblade_mgmt_vip           => <Management VIP of the FlashBlade>,
#    flashblade_data_vip           => <Data VIP address of FlashBlade>,
#  }
#
define manila::backend::flashblade (
  $flashblade_api,
  $flashblade_data_vip,
  $flashblade_mgmt_vip,
  $flashblade_eradicate      = true,
  $share_backend_name        = $name,
  $backend_availability_zone = $facts['os_service_default'],
  $package_ensure            = 'present',
) {

  include manila::deps
  include manila::params

  validate_legacy(String, 'validate_string', $flashblade_api)

  $flashblade_share_driver = 'manila.share.drivers.purestorage.flashblade.FlashBladeShareDriver'

  manila_config {
    "${share_backend_name}/share_driver":                 value => $flashblade_share_driver;
    "${share_backend_name}/driver_handles_share_servers": value => false;
    "${share_backend_name}/flashblade_eradicate":         value => $flashblade_eradicate;
    "${share_backend_name}/flashblade_api":               value => $flashblade_api, secret => true;
    "${share_backend_name}/flashblade_mgmt_vip":          value => $flashblade_mgmt_vip;
    "${share_backend_name}/flashblade_data_vip":          value => $flashblade_data_vip;
    "${share_backend_name}/share_backend_name":           value => $share_backend_name;
    "${share_backend_name}/backend_availability_zone":    value => $backend_availability_zone;
  }

  ensure_packages('nfs-client', {
    name   => $::manila::params::nfs_client_package_name,
    ensure => $package_ensure,
    tag    => 'manila-support-package',
  })

}

