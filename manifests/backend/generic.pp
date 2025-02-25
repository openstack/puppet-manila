# ==define manila::backend::generic
#
# Configures Manila to use the generic share driver
#
# ===Parameters
#
# [*driver_handles_share_servers*]
#  (required) Denotes whether the driver should handle the responsibility of
#  managing share servers. This must be set to false if the driver is to
#  operate without managing share servers.
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
# [*smb_template_config_path*]
#   (optional) Path to smb config.
#   Defaults to $facts['os_service_default'].
#
# [*volume_name_template*]
#   (optional) Volume name template.
#   Defaults to $facts['os_service_default'].
#
# [*volume_snapshot_name_template*]
#   (optional) Volume snapshot name template.
#   Defaults to $facts['os_service_default'].
#
# [*share_mount_path*]
#   (optional) Parent path in service instance where shares will be mounted.
#   Defaults to $facts['os_service_default'].
#
# [*max_time_to_create_volume*]
#   (optional) Maximum time to wait for creating cinder volume.
#   Defaults to $facts['os_service_default'].
#
# [*max_time_to_attach*]
#   (optional) Maximum time to wait for attaching cinder volume.
#   Defaults to $facts['os_service_default'].
#
# [*service_instance_smb_config_path*]
#   (optional) Path to smb config in service instance.
#   Defaults to $facts['os_service_default'].
#
# [*share_volume_fstype*]
#   (optional) Filesystem type of the share volume.
#   Choices: 'ext4', 'ext3'
#   Defaults to $facts['os_service_default'].
#
# [*share_helpers*]
#   (optional) Specify list of share export helpers.
#   Defaults to $facts['os_service_default'].
#
# [*cinder_volume_type*]
#   (optional) Name or id of cinder volume type which will be used for all
#   volumes created by driver.
#   Defaults to $facts['os_service_default'].
#
# [*delete_share_server_with_last_share*]
#   (optional) With this option is set to True share server will be deleted
#   on deletion of last share.
#   Defaults to $facts['os_service_default'].
#
# [*unmanage_remove_access_rules*]
#   (optional) If set to True, then manila will deny access and remove all
#   access rules on share unmanage. If set to False - nothing will be changed.
#   Defaults to $facts['os_service_default'].
#
# [*automatic_share_server_cleanup*]
#   (optional) If set to True, then Manila will delete all share servers which
#   were unused more than specified time. If set to False, automatic deletion
#   of share servers will be disabled.
#   Defaults to $facts['os_service_default'].
#
# [*reserved_share_percentage*]
#   (optional) The percentage of backend capacity reserved.
#   Defaults to $facts['os_service_default']
#
# [*reserved_share_from_snapshot_percentage*]
#   (optional) The percentage of backend capacity reserved. Used for shares
#   created from the snapshot.
#   Defaults to $facts['os_service_default']
#
# [*reserved_share_extend_percentage*]
#   (optional) The percentage of backend capacity reserved for share extend
#   operation.
#   Defaults to $facts['os_service_default']
#
define manila::backend::generic (
  $driver_handles_share_servers,
  $share_backend_name                      = $name,
  $backend_availability_zone               = $facts['os_service_default'],
  $smb_template_config_path                = $facts['os_service_default'],
  $volume_name_template                    = $facts['os_service_default'],
  $volume_snapshot_name_template           = $facts['os_service_default'],
  $share_mount_path                        = $facts['os_service_default'],
  $max_time_to_create_volume               = $facts['os_service_default'],
  $max_time_to_attach                      = $facts['os_service_default'],
  $service_instance_smb_config_path        = $facts['os_service_default'],
  $share_volume_fstype                     = $facts['os_service_default'],
  $share_helpers                           = $facts['os_service_default'],
  $cinder_volume_type                      = $facts['os_service_default'],
  $delete_share_server_with_last_share     = $facts['os_service_default'],
  $unmanage_remove_access_rules            = $facts['os_service_default'],
  $automatic_share_server_cleanup          = $facts['os_service_default'],
  $reserved_share_percentage               = $facts['os_service_default'],
  $reserved_share_from_snapshot_percentage = $facts['os_service_default'],
  $reserved_share_extend_percentage        = $facts['os_service_default'],
) {

  include manila::deps

  $share_driver = 'manila.share.drivers.generic.GenericShareDriver'

  manila_config {
    "${name}/driver_handles_share_servers":            value => $driver_handles_share_servers;
    "${name}/share_backend_name":                      value => $share_backend_name;
    "${name}/backend_availability_zone":               value => $backend_availability_zone;
    "${name}/share_driver":                            value => $share_driver;
    "${name}/smb_template_config_path":                value => $smb_template_config_path;
    "${name}/volume_name_template":                    value => $volume_name_template;
    "${name}/volume_snapshot_name_template":           value => $volume_snapshot_name_template;
    "${name}/share_mount_path":                        value => $share_mount_path;
    "${name}/max_time_to_create_volume":               value => $max_time_to_create_volume;
    "${name}/max_time_to_attach":                      value => $max_time_to_attach;
    "${name}/service_instance_smb_config_path":        value => $service_instance_smb_config_path;
    "${name}/share_volume_fstype":                     value => $share_volume_fstype;
    "${name}/share_helpers":                           value => join(any2array($share_helpers), ',');
    "${name}/cinder_volume_type":                      value => $cinder_volume_type;
    "${name}/delete_share_server_with_last_share":     value => $delete_share_server_with_last_share;
    "${name}/unmanage_remove_access_rules":            value => $unmanage_remove_access_rules;
    "${name}/automatic_share_server_cleanup":          value => $automatic_share_server_cleanup;
    "${name}/reserved_share_percentage":               value => $reserved_share_percentage;
    "${name}/reserved_share_from_snapshot_percentage": value => $reserved_share_from_snapshot_percentage;
    "${name}/reserved_share_extend_percentage":        value => $reserved_share_extend_percentage;
  }
}
