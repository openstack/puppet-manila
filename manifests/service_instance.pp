# ==define manila::service_instance
#
# ===Parameters
#
# [*service_instance_user*]
#   (required) User in service instance.
#
# [*service_instance_password*]
#   (required) Password to service instance user.
#
# [*create_service_image*]
#   (optional) Upload the service image to glance.
#   Defaults to: true
#
# [*service_image_name*]
#   (optional) Name of image in glance, that will be used to create
#    service instance.
#   Defaults to: 'manila-service-image'
#
# [*service_image_location*]
#   (optional) URL or pathname to the service image. This will be
#   loaded into Glance. This is required when create_service_image is true.
#
# [*service_instance_name_template*]
#   (optional) Name of service instance.
#   Defaults to: 'manila_service_instance_%s'
#
# [*manila_service_keypair_name*]
#   (optional) Name of keypair that will be created and used
#    for service instance.
#   Defaults to: 'manila-service'
#
# [*path_to_public_key*]
#   (optional) Path to hosts public key.
#   Defaults to: '~/.ssh/id_rsa.pub'
#
# [*path_to_private_key*]
#   (optional) Path to hosts private key.
#   Defaults to: '~/.ssh/id_rsa'
#
# [*max_time_to_build_instance*]
#   (optional) Maximum time to wait for creating service instance.
#   Defaults to: 300
#
# [*service_instance_security_group*]
#   (optional) Name of security group, that will be used for
#    service instance creation.
#   Defaults to: 'manila-service'
#
# [*service_instance_flavor_id*]
#   (optional) ID of flavor, that will be used for service instance
#    creation.
#   Defaults to: 1
#
# [*service_network_name*]
#   (optional) Name of manila service network.
#   Defaults to: 'manila_service_network'
#
# [*service_network_cidr*]
#   (optional) CIDR of manila service network.
#   Defaults to: '10.254.0.0/16'
#
# [*service_network_division_mask*]
#   (optional) This mask is used for dividing service network into
#    subnets, IP capacity of subnet with this mask directly
#    defines possible amount of created service VMs
#    per tenant's subnet.
#   Defaults to: 28
#
# [*interface_driver*]
#   (optional) Vif driver.
#   Defaults to: 'manila.network.linux.interface.OVSInterfaceDriver'
#
# [*connect_share_server_to_tenant_network*]
#   (optional) Attach share server directly to share network.
#   Defaults to: false
#
define manila::service_instance (
  $service_instance_user,
  $service_instance_password,
  $create_service_image                   = true,
  $service_image_name                     = 'manila-service-image',
  $service_image_location                 = undef,
  $service_instance_name_template         = 'manila_service_instance_%s',
  $manila_service_keypair_name            = 'manila-service',
  $path_to_public_key                     = '~/.ssh/id_rsa.pub',
  $path_to_private_key                    = '~/.ssh/id_rsa',
  $max_time_to_build_instance             = 300,
  $service_instance_security_group        = 'manila-service',
  $service_instance_flavor_id             = 1,
  $service_network_name                   = 'manila_service_network',
  $service_network_cidr                   = '10.254.0.0/16',
  $service_network_division_mask          = 28,
  $interface_driver                       = 'manila.network.linux.interface.OVSInterfaceDriver',
  $connect_share_server_to_tenant_network = false,
) {

  include manila::deps

  warning('The manila::service_instance defined type has been deprecated. \
use the manila::backend::service_instance defined type.')

  manila::backend::service_instance { $name:
    service_instance_user                  => $service_instance_user,
    service_instance_password              => $service_instance_password,
    create_service_image                   => $create_service_image,
    service_image_name                     => $service_image_name,
    service_image_location                 => $service_image_location,
    service_instance_name_template         => $service_instance_name_template,
    manila_service_keypair_name            => $manila_service_keypair_name,
    path_to_public_key                     => $path_to_public_key,
    path_to_private_key                    => $path_to_private_key,
    max_time_to_build_instance             => $max_time_to_build_instance,
    service_instance_security_group        => $service_instance_security_group,
    service_instance_flavor_id             => $service_instance_flavor_id,
    service_network_name                   => $service_network_name,
    service_network_cidr                   => $service_network_cidr,
    service_network_division_mask          => $service_network_division_mask,
    interface_driver                       => $interface_driver,
    connect_share_server_to_tenant_network => $connect_share_server_to_tenant_network,
  }
}
