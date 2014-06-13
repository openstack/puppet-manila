#
class manila::volume::iscsi (
  $iscsi_ip_address,
  $volume_group      = 'manila-volumes',
  $iscsi_helper      = $manila::params::iscsi_helper,
) {

  manila::backend::iscsi { 'DEFAULT':
    iscsi_ip_address   => $iscsi_ip_address,
    volume_group       => $volume_group,
    iscsi_helper       => $iscsi_helper
  }
}
