# == Class: manila::share::netapp
#
# Configures Manila to use the NetApp share driver
#
# === Parameters
#NTAP: check if these parameters are actually optional or required
#NTAP: copy the more descriptive descriptions from puppet-cinder?
#
# [*netapp_nas_storage_family*]
# (required) The storage family type used on the storage system; valid values
# are ontap_7mode for using Data ONTAP operating in 7-Mode or ontap_cluster
# for using clustered Data ONTAP.
# Defaults to ontap_cluster
#
# [*netapp_nas_transport_type*]
# (optional) The transport protocol used when communicating with ONTAPI on the
# storage system or proxy server. Valid values are http or https.
# Defaults to http
#
# [*netapp_nas_login*]
# (required) Administrative user account name used to access the storage
# system or proxy server.
#
# [*netapp_nas_password*]
# (required) Password for the administrative user account specified in the
# netapp_nas_login parameter.
#
# [*netapp_nas_server_hostname*]
# (required) The hostname (or IP address) for the storage system or proxy
# server.
#
# [*netapp_nas_size_multiplier*]
# (optional) The quantity to be multiplied by the requested volume size to
# ensure enough space is available on the virtual storage server (Vserver) to
# fulfill the volume creation request.
# Defaults to 1.2
#
# [*netapp_nas_vfiler*]
#NTAP: edit this definition here
# (optional) Vfiler to use for provisioning.
#
# [*netapp_nas_volume_name_template*]
# (optional) NetApp volume name template.
#
# [*netapp_vserver_name_template*]
# (optional) Name template to use for new vserver.
#
# [*netapp_lif_name_template*]
# (optional) Lif name template
#
# [*netapp_aggregate_name_search_pattern*]
# (optional) Pattern for searching available aggregates
#  for provisioning.
#
# [*netapp_root_volume_aggregate*]
# (optional) Name of aggregate to create root volume on.
#
# [*netapp_root_volume_name*]
# (optional) Root volume name.
#
# === Examples
#
#  class { 'manila::share::netapp':
#    netapp_login => 'clusterAdmin',
#    netapp_password => 'password',
#    netapp_server_hostname => 'netapp.mycorp.com',
#    netapp_server_port => '443',
#    netapp_transport_type => 'https',
#    netapp_vserver => 'openstack-vserver',
#  }
#
#NTAP: are these intented right?
class manila::share::netapp (
    $netapp_nas_storage_family = 'ontap_cluster',
    $netapp_nas_transport_type = 'http',
    $netapp_nas_login = 'admin',
    $netapp_nas_password = undef,
    $netapp_nas_server_hostname	= undef,
    $netapp_nas_size_multiplier	= 1.2,
    $netapp_nas_vfiler = undef,
    $netapp_nas_volume_name_template= 'share_%(share_id)s',
    $netapp_vserver_name_template = 'os_%s',
    $netapp_lif_name_template = 'os_%(net_allocation_id)s',
    $netapp_aggregate_name_search_pattern	= '(.*)',
    $netapp_root_volume_aggregate = undef,
    $netapp_root_volume_name = 'root',
) {

  manila::backend::netapp { 'DEFAULT':
    netapp_nas_storage_family             => $netapp_nas_storage_family,
    netapp_nas_transport_type				      => $netapp_nas_transport_type,
    netapp_nas_login				              => $netapp_nas_login,
    netapp_nas_password				            => $netapp_nas_password,
    netapp_nas_server_hostname				    => $netapp_nas_server_hostname,
    netapp_nas_size_multiplier				    => $netapp_nas_size_multiplier,
    netapp_nas_vfiler				              => $netapp_nas_vfiler,
    netapp_nas_volume_name_template       => $netapp_nas_volume_name_template,
    netapp_vserver_name_template				  => $netapp_vserver_name_template,
    netapp_lif_name_template				      => $netapp_lif_name_template,
    netapp_aggregate_name_search_pattern  => $netapp_aggregate_name_search_pattern,
    netapp_root_volume_aggregate				  => $netapp_root_volume_aggregate,
    netapp_root_volume_name               => $netapp_root_volume_name,
  }
}
