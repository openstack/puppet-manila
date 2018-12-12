# == Class: manila::params
#
# Parameters for puppet-manila
#
class manila::params {

  include ::openstacklib::defaults

  if ($::os_package_type == 'debian') or ($::os['name'] == 'Fedora') or
    ($::os['family'] == 'RedHat' and Integer.new($::os['release']['major']) > 7) {
    $pyvers = '3'
  } else {
    $pyvers = ''
  }

  $client_package       = "python${pyvers}-manilaclient"
  $db_sync_command      = 'manila-manage db sync'
  $lio_package_name     = 'targetcli'
  $group                = 'manila'

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
      $manila_wsgi_script_path     = '/usr/lib/cgi-bin/manila'
      $manila_wsgi_script_source   = '/usr/bin/manila-wsgi'
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
      $manila_wsgi_script_path     = '/var/www/cgi-bin/manila'
      $manila_wsgi_script_source   = '/usr/bin/manila-wsgi'
    }
    default: {
      fail("unsupported osfamily ${::osfamily}, currently Debian and Redhat are the only supported platforms")
    }

  }
}
