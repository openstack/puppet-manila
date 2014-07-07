# == Class: manila::share::nexenta
#
# Setups Manila with Nexenta share driver.
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
# [*nexenta_share*]
#   (optional) Pool on SA that will hold all shares. Defaults to 'manila'.
#
# [*nexenta_target_prefix*]
#   (optional) IQN prefix for iSCSI targets. Defaults to 'iqn:'.
#
# [*nexenta_target_group_prefix*]
#   (optional) Prefix for iSCSI target groups on SA. Defaults to 'manila/'.
#
# [*nexenta_blocksize*]
#   (optional) Block size for shares. Defaults to '8k'.
#
# [*nexenta_sparse*]
#   (optional) Flag to create sparse shares. Defaults to true.
#
class manila::share::nexenta (
  $nexenta_user,
  $nexenta_password,
  $nexenta_host,
  $nexenta_share                = 'manila',
  $nexenta_target_prefix        = 'iqn:',
  $nexenta_target_group_prefix  = 'manila/',
  $nexenta_blocksize            = '8k',
  $nexenta_sparse               = true
) {

  manila::backend::nexenta { 'DEFAULT':
    nexenta_user                => $nexenta_user,
    nexenta_password            => $nexenta_password,
    nexenta_host                => $nexenta_host,
    nexenta_share               => $nexenta_share,
    nexenta_target_prefix       => $nexenta_target_prefix,
    nexenta_target_group_prefix => $nexenta_target_group_prefix,
    nexenta_blocksize           => $nexenta_blocksize,
    nexenta_sparse              => $nexenta_sparse,
  }
}
