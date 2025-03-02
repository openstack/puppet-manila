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
# [*reserved_share_percentage*]
#   (optional) The percentage of backend capacity reserved.
#   Defaults to: $facts['os_service_default']
#
# [*reserved_share_from_snapshot_percentage*]
#   (optional) The percentage of backend capacity reserved. Used for shares
#   created from the snapshot.
#   Defaults to: $facts['os_service_default']
#
# [*reserved_share_extend_percentage*]
#   (optional) The percentage of backend capacity reserved for share extend
#   operation.
#   Defaults to: $facts['os_service_default']
#
# [*max_over_subscription_ratio*]
#   (optional) Float representation of the over subscription ratio when thin
#   provisionig is involved.
#   Defaults to: $facts['os_service_default']
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
  String[1] $flashblade_api,
  String[1] $flashblade_data_vip,
  String[1] $flashblade_mgmt_vip,
  $flashblade_eradicate                    = true,
  $share_backend_name                      = $name,
  $backend_availability_zone               = $facts['os_service_default'],
  $reserved_share_percentage               = $facts['os_service_default'],
  $reserved_share_from_snapshot_percentage = $facts['os_service_default'],
  $reserved_share_extend_percentage        = $facts['os_service_default'],
  $max_over_subscription_ratio             = $facts['os_service_default'],
  $package_ensure                          = 'present',
) {

  include manila::deps
  include manila::params

  $flashblade_share_driver = 'manila.share.drivers.purestorage.flashblade.FlashBladeShareDriver'

  manila_config {
    "${share_backend_name}/share_driver":                            value => $flashblade_share_driver;
    "${share_backend_name}/driver_handles_share_servers":            value => false;
    "${share_backend_name}/flashblade_eradicate":                    value => $flashblade_eradicate;
    "${share_backend_name}/flashblade_api":                          value => $flashblade_api, secret => true;
    "${share_backend_name}/flashblade_mgmt_vip":                     value => $flashblade_mgmt_vip;
    "${share_backend_name}/flashblade_data_vip":                     value => $flashblade_data_vip;
    "${share_backend_name}/share_backend_name":                      value => $share_backend_name;
    "${share_backend_name}/backend_availability_zone":               value => $backend_availability_zone;
    "${share_backend_name}/reserved_share_percentage":               value => $reserved_share_percentage;
    "${share_backend_name}/reserved_share_from_snapshot_percentage": value => $reserved_share_from_snapshot_percentage;
    "${share_backend_name}/reserved_share_extend_percentage":        value => $reserved_share_extend_percentage;
    "${share_backend_name}/max_over_subscription_ratio":             value => $max_over_subscription_ratio;
  }

  ensure_packages('nfs-client', {
    name   => $::manila::params::nfs_client_package_name,
    ensure => $package_ensure,
  })
  Package<| title == 'nfs-client' |> { tag +> 'manila-support-package' }

}

