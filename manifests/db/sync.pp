#
class manila::db::sync {

  include ::manila::params

  Exec['manila-manage db_sync'] ~> Service<| tag == 'manila-service' |>
  Package<| tag == 'manila-package' |> ~> Exec['manila-manage db_sync']

  Manila_config<| title == 'database/connection' |> ~> Exec['manila-manage db_sync']

  exec { 'manila-manage db_sync':
    command     => $::manila::params::db_sync_command,
    path        => '/usr/bin',
    user        => 'manila',
    refreshonly => true,
    logoutput   => 'on_failure',
  }
}
