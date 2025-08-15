#
# Class to execute manila dbsync
#
# ==Parameters
#
# [*db_sync_timeout*]
#   (Optional) Timeout for the execution of the db_sync
#   Defaults to 300
#
class manila::db::sync(
  $db_sync_timeout = 300,
) {

  include manila::deps
  include manila::params

  exec { 'manila-manage db_sync':
    command     => $manila::params::db_sync_command,
    path        => '/usr/bin',
    user        => $manila::params::user,
    refreshonly => true,
    try_sleep   => 5,
    tries       => 10,
    timeout     => $db_sync_timeout,
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
