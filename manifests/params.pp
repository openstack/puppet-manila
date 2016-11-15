# == Class: manila::params
#
# Parameters for puppet-manila
#
class manila::params {

  include ::openstacklib::defaults

  $manila_conf          = '/etc/manila/manila.conf'
  $manila_paste_api_ini = '/etc/manila/api-paste.ini'
  $client_package       = 'python-manilaclient'
  $db_sync_command      = 'manila-manage db sync'
  $lio_package_name     = 'targetcli'

  case $::osfamily {
    'Debian': {
      $package_name                = 'manila-common'
      $api_package                 = 'manila-api'
      $api_service                 = 'manila-api'
      $scheduler_package           = 'manila-scheduler'
      $scheduler_service           = 'manila-scheduler'
      $share_package               = 'manila-share'
      $share_service               = 'manila-share'
      $gluster_client_package_name = 'glusterfs-client'
      $gluster_package_name        = 'glusterfs-common'
    }
    'RedHat': {
      $package_name                = 'openstack-manila'
      $api_package                 = false
      $api_service                 = 'openstack-manila-api'
      $scheduler_package           = false
      $scheduler_service           = 'openstack-manila-scheduler'
      $share_package               = 'openstack-manila-share'
      $share_service               = 'openstack-manila-share'
      $gluster_client_package_name = 'glusterfs-fuse'
      $gluster_package_name        = 'glusterfs'
    }
    default: {
      fail("unsupported osfamily ${::osfamily}, currently Debian and Redhat are the only supported platforms")
    }

  }
}
