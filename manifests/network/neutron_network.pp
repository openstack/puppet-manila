# == define: manila::network::neutron_network
#
# Setup and configure the Neutron network plugin
#
# === Parameters
#
# [*neutron_physical_net_name*]
#  (required) The name of the physical network to determine which net segment
#  is used.
#
# [*network_plugin_ipv4_enabled*]
#  (optional) Whether to support Ipv4 network resource.
#  Defaults to $facts['os_service_default'].
#
# [*network_plugin_ipv6_enabled*]
#  (optional) whether to support IPv6 network resource.
#  Defaults to $facts['os_service_default'].
#
define manila::network::neutron_network (
  $neutron_physical_net_name,
  $network_plugin_ipv4_enabled = $facts['os_service_default'],
  $network_plugin_ipv6_enabled = $facts['os_service_default'],
) {

  $neutron_single_plugin_name = 'manila.network.neutron.neutron_network_plugin.NeutronNetworkPlugin'

  manila_config {
    "${name}/network_api_class":           value => $neutron_single_plugin_name;
    "${name}/neutron_physical_net_name":   value => $neutron_physical_net_name;
    "${name}/network_plugin_ipv4_enabled": value => $network_plugin_ipv4_enabled;
    "${name}/network_plugin_ipv6_enabled": value => $network_plugin_ipv6_enabled;
  }
}
