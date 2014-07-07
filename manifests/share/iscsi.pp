#
class manila::share::iscsi (
  $iscsi_ip_address,
  $share_group       = 'manila-shares',
  $iscsi_helper      = $manila::params::iscsi_helper,
) {

  manila::backend::iscsi { 'DEFAULT':
    iscsi_ip_address   => $iscsi_ip_address,
    share_group        => $share_group,
    iscsi_helper       => $iscsi_helper
  }
}
