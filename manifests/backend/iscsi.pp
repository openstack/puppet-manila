#
# Define: manila::backend::iscsi
# Parameters:
#
# [*share_backend_name*]
#   (optional) Allows for the share_backend_name to be separate of $name.
#   Defaults to: $name
#
#
define manila::backend::iscsi (
  $iscsi_ip_address,
  $share_backend_name = $name,
  $share_group        = 'manila-shares',
  $iscsi_helper        = $::manila::params::iscsi_helper,
) {

  include manila::params

  manila_config {
    "${name}/share_backend_name":  value => $share_backend_name;
    "${name}/iscsi_ip_address":     value => $iscsi_ip_address;
    "${name}/iscsi_helper":         value => $iscsi_helper;
    "${name}/share_group":         value => $share_group;
  }

  case $iscsi_helper {
    'tgtadm': {
      package { 'tgt':
        ensure => present,
        name   => $::manila::params::tgt_package_name,
      }

      if($::osfamily == 'RedHat') {
        file_line { 'manila include':
          path    => '/etc/tgt/targets.conf',
          line    => 'include /etc/manila/shares/*',
          match   => '#?include /',
          require => Package['tgt'],
          notify  => Service['tgtd'],
        }
      }

      service { 'tgtd':
        ensure  => running,
        name    => $::manila::params::tgt_service_name,
        enable  => true,
        require => Class['manila::share'],
      }
    }

    'lioadm': {
      package { 'targetcli':
        ensure => present,
        name   => $::manila::params::lio_package_name,
      }
    }

    default: {
      fail("Unsupported iscsi helper: ${iscsi_helper}.")
    }
  }

}
