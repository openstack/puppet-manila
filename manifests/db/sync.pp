#
class manila::db::sync {

  include ::manila::params
  include ::manila::deps

  exec { 'manila-manage db_sync':
    command     => $::manila::params::db_sync_command,
    path        => '/usr/bin',
    user        => 'manila',
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    logoutput   => 'on_failure',
    subscribe   => [
      Anchor['manila::install::end'],
      Anchor['manila::config::end'],
      Anchor['manila::dbsync::begin']
    ],
    notify      => Anchor['manila::dbsync::end'],
    tag         => 'openstack-db',
  }
}
