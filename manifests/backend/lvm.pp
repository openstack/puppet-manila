#
# == Defines: manila::backend::lvm
#
# Configures Manila to use LVM as a share driver
#
# === Parameters
# [*lvm_share_export_ips*]
#  (required) List of IPs to export shares belonging to the LVM storage driver.
#
# [*share_backend_name*]
#   (optional) Name of the backend in manila.conf that these settings will
#   reside in.
#   Defaults to: $name
#
# [*backend_availability_zone*]
#   (Optional) Availability zone for this share backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $facts['os_service_default'].
#
# [*lvm_share_export_root*]
#  (optional) Base folder where exported shares are located.
#  Defaults to: $facts['os_service_default']
#
# [*lvm_share_mirrors*]
#  (optional) If set, create LVMs with multiple mirrors. Note that this requires
#  lvm_mirrors + 2 PVs with available space.
#  Defaults to: $facts['os_service_default']

# [*lvm_share_volume_group*]
#  (optional) Name for the VG that will contain exported shares. (string value)
#  Defaults to: $facts['os_service_default']

# [*lvm_share_helpers*]
#  (optional) Specify list of share export helpers. (list value)
#  Defaults to: $facts['os_service_default']
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
# DEPRECATED PARAMETERS
#
# [*driver_handles_share_servers*]
#  (optional) Denotes whether the driver should handle the responsibility of
#  managing share servers. This must be set to false if the driver is to
#  operate without managing share servers.
#  This parameter is now ignored and the option is always set to False.
#  Defaults to: undef
#
define manila::backend::lvm (
  $lvm_share_export_ips,
  $share_backend_name                      = $name,
  $backend_availability_zone               = $facts['os_service_default'],
  $lvm_share_export_root                   = $facts['os_service_default'],
  $lvm_share_mirrors                       = $facts['os_service_default'],
  $lvm_share_volume_group                  = $facts['os_service_default'],
  $lvm_share_helpers                       = $facts['os_service_default'],
  $reserved_share_percentage               = $facts['os_service_default'],
  $reserved_share_from_snapshot_percentage = $facts['os_service_default'],
  $reserved_share_extend_percentage        = $facts['os_service_default'],
  # DEPRECATED PARAMETERS
  $driver_handles_share_servers            = undef,
) {

  include manila::deps
  $share_driver = 'manila.share.drivers.lvm.LVMShareDriver'

  if $driver_handles_share_servers != undef {
    warning('The manila::backend::lvm::driver_handles_share_servers parameter is deprecated \
and has no effect.')
  }

  manila_config {
    "${name}/share_backend_name":                      value => $share_backend_name;
    "${name}/backend_availability_zone":               value => $backend_availability_zone;
    "${name}/share_driver":                            value => $share_driver;
    "${name}/driver_handles_share_servers":            value => false;
    "${name}/lvm_share_export_ips":                    value => join(any2array($lvm_share_export_ips),',');
    "${name}/lvm_share_export_root":                   value => $lvm_share_export_root;
    "${name}/lvm_share_mirrors":                       value => $lvm_share_mirrors;
    "${name}/lvm_share_volume_group":                  value => $lvm_share_volume_group;
    "${name}/lvm_share_helpers":                       value => join(any2array($lvm_share_helpers), ',');
    "${name}/reserved_share_percentage":               value => $reserved_share_percentage;
    "${name}/reserved_share_from_snapshot_percentage": value => $reserved_share_from_snapshot_percentage;
    "${name}/reserved_share_extend_percentage":        value => $reserved_share_extend_percentage;
  }
}
