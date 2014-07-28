#
class manila::share::generic (
  $service_image_name = 'manila-service-image',
  $service_instance_name_template = 'manila_service_instance_%s',
  $service_instance_user = undef,
  $service_instance_password = undef,
  $manila_service_keypair_name = 'manila-service',
  $path_to_public_key = '~/.ssh/id_rsa.pub',
  $path_to_private_key = '~/.ssh/id_rsa',
  $max_time_to_build_instance = 300,
  $service_instance_security_group = 'manila-service',
  $service_instance_flavor_id = 100,
  $service_network_name = 'manila_service_network',
  $service_network_cidr = '10.254.0.0/16',
  $interface_driver = 'manila.network.linux.interface.OVSInterfaceDriver',
  $os_region_name = undef,
) {

  manila::backend::generic { 'DEFAULT':
    service_image_name                => $service_image_name,
    service_instance_name_template    => $service_instance_name_template,
    service_instance_user             => $service_instance_user,
    service_instance_password         => $service_instance_password,
    manila_service_keypair_name       => $manila_service_keypair_name,
    path_to_public_key                => $path_to_public_key,
    path_to_private_key               => $path_to_private_key,
    max_time_to_build_instance        => $max_time_to_build_instance,
    service_instance_security_group   => $service_instance_security_group,
    service_instance_flavor_id        => $service_instance_flavor_id,
    service_network_name              => $service_network_name,
    service_network_cidr              => $service_network_cidr,
    interface_driver                  => $interface_driver,
    os_region_name                    => $os_region_name,
  }
}
