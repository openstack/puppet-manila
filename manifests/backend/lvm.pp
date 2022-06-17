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
#   Defaults to $::os_service_default.
#
# [*driver_handles_share_servers*]
#  (optional) Denotes whether the driver should handle the responsibility of
#  managing share servers. This must be set to false if the driver is to
#  operate without managing share servers.
#  Defaults to: $::os_service_default
#
# [*lvm_share_export_root*]
#  (optional) Base folder where exported shares are located.
#  Defaults to: $::os_service_default
#
# [*lvm_share_mirrors*]
#  (optional) If set, create LVMs with multiple mirrors. Note that this requires
#  lvm_mirrors + 2 PVs with available space.
#  Defaults to: $::os_service_default

# [*lvm_share_volume_group*]
#  (optional) Name for the VG that will contain exported shares. (string value)
#  Defaults to: $::os_service_default

# [*lvm_share_helpers*]
#  (optional) Specify list of share export helpers. (list value)
#  Defaults to: $::os_service_default
#
define manila::backend::lvm (
  $lvm_share_export_ips,
  $share_backend_name           = $name,
  $backend_availability_zone    = $::os_service_default,
  $driver_handles_share_servers = $::os_service_default,
  $lvm_share_export_root        = $::os_service_default,
  $lvm_share_mirrors            = $::os_service_default,
  $lvm_share_volume_group       = $::os_service_default,
  $lvm_share_helpers            = $::os_service_default,
) {

  include manila::deps
  $share_driver = 'manila.share.drivers.lvm.LVMShareDriver'

  manila_config {
    "${name}/share_backend_name":           value => $share_backend_name;
    "${name}/backend_availability_zone":    value => $backend_availability_zone;
    "${name}/share_driver":                 value => $share_driver;
    "${name}/driver_handles_share_servers": value => $driver_handles_share_servers;
    "${name}/lvm_share_export_ips":         value => join(any2array($lvm_share_export_ips),',');
    "${name}/lvm_share_export_root":        value => $lvm_share_export_root;
    "${name}/lvm_share_mirrors":            value => $lvm_share_mirrors;
    "${name}/lvm_share_volume_group":       value => $lvm_share_volume_group;
    "${name}/lvm_share_helpers":            value => join(any2array($lvm_share_helpers), ',');
  }
}
