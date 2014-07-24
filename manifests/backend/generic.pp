# ==define manila::backend::generic
#
# ===Parameters
# [*share_backend_name*]
#   (optional) Allows for the share_backend_name to be separate of $name.
#   Defaults to: $name
#
#
define manila::backend::generic (
  $share_backend_name = $name,
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
) {

  manila_config {
    "${name}/share_backend_name":  value => $share_backend_name;
    "${name}/share_driver":        value =>
    'manila.share.drivers.generic.GenericShareDriver';
    "${name}/share_backend_name":                value => $share_backend_name;
    "${name}/service_image_name":                value => $service_image_name;
    "${name}/service_instance_name_template":    value => $service_instance_name_template;
    "${name}/service_instance_user":             value => $service_instance_user;
    "${name}/service_instance_password":         value => $service_instance_password;
    "${name}/manila_service_keypair_name":       value => $manila_service_keypair_name;
    "${name}/path_to_public_key":                value => $path_to_public_key;
    "${name}/path_to_private_key":               value => $path_to_private_key;
    "${name}/max_time_to_build_instance":        value => $max_time_to_build_instance;
    "${name}/service_instance_security_group":   value => $service_instance_security_group;
    "${name}/service_instance_flavor_id":        value => $service_instance_flavor_id;
    "${name}/service_network_name":              value => $service_network_name;
    "${name}/service_network_cidr":              value => $service_network_cidr;
    "${name}/interface_driver":                  value => $interface_driver;
    }
}
