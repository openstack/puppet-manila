# $volume_name_template = volume-%s
class manila::volume (
  $package_ensure = 'present',
  $enabled        = true,
  $manage_service = true
) {

  include manila::params

  Manila_config<||> ~> Service['manila-volume']
  Manila_api_paste_ini<||> ~> Service['manila-volume']
  Exec<| title == 'manila-manage db_sync' |> ~> Service['manila-volume']

  if $::manila::params::volume_package {
    Package['manila-volume'] -> Manila_config<||>
    Package['manila-volume'] -> Manila_api_paste_ini<||>
    Package['manila']        -> Package['manila-volume']
    Package['manila-volume'] -> Service['manila-volume']
    package { 'manila-volume':
      ensure => $package_ensure,
      name   => $::manila::params::volume_package,
    }
  }

  if $manage_service {
    if $enabled {
      $ensure = 'running'
    } else {
      $ensure = 'stopped'
    }
  }

  service { 'manila-volume':
    ensure    => $ensure,
    name      => $::manila::params::volume_service,
    enable    => $enabled,
    hasstatus => true,
    require   => Package['manila'],
  }
}
