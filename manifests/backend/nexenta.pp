# == Class: manila::backend::nexenta
#
# Setups Manila with Nexenta volume driver.
#
# === Parameters
#
# [*nexenta_user*]
#   (required) User name to connect to Nexenta SA.
#
# [*nexenta_password*]
#   (required) Password to connect to Nexenta SA.
#
# [*nexenta_host*]
#   (required) IP address of Nexenta SA.
#
# [*volume_backend_name*]
#   (optional) Allows for the volume_backend_name to be separate of $name.
#   Defaults to: $name
#
# [*nexenta_volume*]
#   (optional) Pool on SA that will hold all volumes. Defaults to 'manila'.
#
# [*nexenta_target_prefix*]
#   (optional) IQN prefix for iSCSI targets. Defaults to 'iqn:'.
#
# [*nexenta_target_group_prefix*]
#   (optional) Prefix for iSCSI target groups on SA. Defaults to 'manila/'.
#
# [*nexenta_blocksize*]
#   (optional) Block size for volumes. Defaults to '8k'.
#
# [*nexenta_sparse*]
#   (optional) Flag to create sparse volumes. Defaults to true.
#
define manila::backend::nexenta (
  $nexenta_user,
  $nexenta_password,
  $nexenta_host,
  $volume_backend_name          = $name,
  $nexenta_volume               = 'manila',
  $nexenta_target_prefix        = 'iqn:',
  $nexenta_target_group_prefix  = 'manila/',
  $nexenta_blocksize            = '8k',
  $nexenta_sparse               = true
) {

  manila_config {
    "${name}/volume_backend_name":         value => $volume_backend_name;
    "${name}/nexenta_user":                value => $nexenta_user;
    "${name}/nexenta_password":            value => $nexenta_password;
    "${name}/nexenta_host":                value => $nexenta_host;
    "${name}/nexenta_volume":              value => $nexenta_volume;
    "${name}/nexenta_target_prefix":       value => $nexenta_target_prefix;
    "${name}/nexenta_target_group_prefix": value => $nexenta_target_group_prefix;
    "${name}/nexenta_blocksize":           value => $nexenta_blocksize;
    "${name}/nexenta_sparse":              value => $nexenta_sparse;
    "${name}/volume_driver":               value => 'manila.volume.drivers.nexenta.volume.NexentaDriver';
  }
}
