# == Class: manila::params
#
# Parameters for puppet-manila
#
class manila::params {
  include openstacklib::defaults

  $client_package   = 'python3-manilaclient'
  $db_sync_command  = 'manila-manage db sync'
  $user             = 'manila'
  $group            = 'manila'

  case $::osfamily {
    'Debian': {
      $lock_path                   = '/var/lock/manila'
      $package_name                = 'manila-common'
      $api_package                 = 'manila-api'
      $api_service                 = 'manila-api'
      $data_package                = 'manila-data'
      $data_service                = 'manila-data'
      $scheduler_package           = 'manila-scheduler'
      $scheduler_service           = 'manila-scheduler'
      $share_package               = 'manila-share'
      $share_service               = 'manila-share'
      $gluster_client_package_name = 'glusterfs-client'
      $gluster_package_name        = 'glusterfs-common'
      $manila_wsgi_script_path     = '/usr/lib/cgi-bin/manila'
      $manila_wsgi_script_source   = '/usr/bin/manila-wsgi'
      $nfs_client_package_name     = 'nfs-common'
    }
    'RedHat': {
      $lock_path                   = '/var/lib/manila/tmp'
      $package_name                = 'openstack-manila'
      $api_package                 = false
      $api_service                 = 'openstack-manila-api'
      $data_package                = false
      $data_service                = 'openstack-manila-data'
      $scheduler_package           = false
      $scheduler_service           = 'openstack-manila-scheduler'
      $share_package               = 'openstack-manila-share'
      $share_service               = 'openstack-manila-share'
      $gluster_client_package_name = 'glusterfs-fuse'
      $gluster_package_name        = 'glusterfs'
      $manila_wsgi_script_path     = '/var/www/cgi-bin/manila'
      $manila_wsgi_script_source   = '/usr/bin/manila-wsgi'
      $nfs_client_package_name     = 'nfs-utils'
    }
    default: {
      fail("unsupported osfamily ${::osfamily}, currently Debian and Redhat are the only supported platforms")
    }

  }
}
