# == define: manila::network::neutron_single_network
#
# Setup and configure the Neutron single network plugin
#
# === Parameters
#
# [*neutron_net_id*]
#  (required) Default Neutron network that will be used for share server
#  creation.
#
# [*neutron_subnet_id*]
#  (required) Default Neutron subnet that will be used for share server
#  creation. Should be assigned to network defined in opt
#  'neutron_net_id'.
#
# [*network_plugin_ipv4_enabled*]
#  (optional) Whether to support Ipv4 network resource.
#  Defaults to $facts['os_service_default'].
#
# [*network_plugin_ipv6_enabled*]
#  (optional) whether to support IPv6 network resource.
#  Defaults to $facts['os_service_default'].
#
define manila::network::neutron_single_network (
  $neutron_net_id,
  $neutron_subnet_id,
  $network_plugin_ipv4_enabled = $facts['os_service_default'],
  $network_plugin_ipv6_enabled = $facts['os_service_default'],
) {
  include manila::deps

  $neutron_single_plugin_name = 'manila.network.neutron.neutron_network_plugin.NeutronSingleNetworkPlugin'

  manila_config {
    "${name}/network_api_class":            value => $neutron_single_plugin_name;
    "${name}/neutron_net_id":               value => $neutron_net_id;
    "${name}/neutron_subnet_id":            value => $neutron_subnet_id;
    "${name}/network_plugin_ipv4_enabled":  value => $network_plugin_ipv4_enabled;
    "${name}/network_plugin_ipv6_enabled":  value => $network_plugin_ipv6_enabled;
  }
}
