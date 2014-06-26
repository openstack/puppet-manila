# == define: manila::backend::rbd
#
# Setup Manila to use the RBD driver.
# Compatible for multiple backends
#
# === Parameters
#
# [*rbd_pool*]
#   (required) Specifies the pool name for the block device driver.
#
# [*rbd_user*]
#   (required) A required parameter to configure OS init scripts and cephx.
#
# [*share_backend_name*]
#   (optional) Allows for the share_backend_name to be separate of $name.
#   Defaults to: $name
#
# [*rbd_ceph_conf*]
#   (optional) Path to the ceph configuration file to use
#   Defaults to '/etc/ceph/ceph.conf'
#
# [*rbd_flatten_share_from_snapshot*]
#   (optional) Enable flatten shares created from snapshots.
#   Defaults to false
#
# [*rbd_secret_uuid*]
#   (optional) A required parameter to use cephx.
#   Defaults to false
#
# [*share_tmp_dir*]
#   (optional) Location to store temporary image files if the share
#   driver does not write them directly to the share
#   Defaults to false
#
# [*rbd_max_clone_depth*]
#   (optional) Maximum number of nested clones that can be taken of a
#   share before enforcing a flatten prior to next clone.
#   A value of zero disables cloning
#   Defaults to '5'
#
# [*glance_api_version*]
#   (optional) DEPRECATED: Use manila::glance Class instead.
#   Glance API version. (Defaults to '2')
#   Setting this parameter cause a duplicate resource declaration
#   with manila::glance
#
define manila::backend::rbd (
  $rbd_pool,
  $rbd_user,
  $share_backend_name              = $name,
  $rbd_ceph_conf                    = '/etc/ceph/ceph.conf',
  $rbd_flatten_share_from_snapshot = false,
  $rbd_secret_uuid                  = false,
  $share_tmp_dir                   = false,
  $rbd_max_clone_depth              = '5',
  # DEPRECATED PARAMETERS
  $glance_api_version               = undef,
) {

  include manila::params

  if $glance_api_version {
    warning('The glance_api_version parameter is deprecated, use glance_api_version of manila::glance class instead.')
  }

  manila_config {
    "${name}/share_backend_name":              value => $share_backend_name;
    "${name}/share_driver":                    value => 'manila.share.drivers.rbd.RBDDriver';
    "${name}/rbd_ceph_conf":                    value => $rbd_ceph_conf;
    "${name}/rbd_user":                         value => $rbd_user;
    "${name}/rbd_pool":                         value => $rbd_pool;
    "${name}/rbd_max_clone_depth":              value => $rbd_max_clone_depth;
    "${name}/rbd_flatten_share_from_snapshot": value => $rbd_flatten_share_from_snapshot;
  }

  if $rbd_secret_uuid {
    manila_config {"${name}/rbd_secret_uuid": value => $rbd_secret_uuid;}
  } else {
    manila_config {"${name}/rbd_secret_uuid": ensure => absent;}
  }

  if $share_tmp_dir {
    manila_config {"${name}/share_tmp_dir": value => $share_tmp_dir;}
  } else {
    manila_config {"${name}/share_tmp_dir": ensure => absent;}
  }

  case $::osfamily {
    'Debian': {
      $override_line    = "env CEPH_ARGS=\"--id ${rbd_user}\""
    }
    'RedHat': {
      $override_line    = "export CEPH_ARGS=\"--id ${rbd_user}\""
    }
    default: {
      fail("unsuported osfamily ${::osfamily}, currently Debian and Redhat are the only supported platforms")
    }
  }

  # Creates an empty file if it doesn't yet exist
  ensure_resource('file', $::manila::params::ceph_init_override, {'ensure' => 'present'})

  ensure_resource('file_line', 'set initscript env', {
    line   => $override_line,
    path   => $::manila::params::ceph_init_override,
    notify => Service['manila-share']
  })

}
