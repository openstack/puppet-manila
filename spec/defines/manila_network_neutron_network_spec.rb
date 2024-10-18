require 'spec_helper'

describe 'manila::network::neutron_network' do
  let(:title) do
    'neutronnet'
  end

  let :params do
    {
      :neutron_physical_net_name => 'br-ex',
    }
  end

  shared_examples 'manila::network::neutron_network' do
    context 'with required parameters' do
      it 'configures neutron single network plugin' do
        is_expected.to contain_manila_config("neutronnet/network_api_class").with_value(
          'manila.network.neutron.neutron_network_plugin.NeutronNetworkPlugin')

        is_expected.to contain_manila_config('neutronnet/neutron_physical_net_name')\
          .with_value('br-ex')
        is_expected.to contain_manila_config('neutronnet/network_plugin_ipv4_enabled')\
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('neutronnet/network_plugin_ipv6_enabled')\
          .with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with custom parameters' do
      before do
        params.merge!({
          :network_plugin_ipv4_enabled => true,
          :network_plugin_ipv6_enabled => false,
        })
      end
      it 'configures neutron single network plugin' do
        is_expected.to contain_manila_config("neutronnet/network_api_class").with_value(
          'manila.network.neutron.neutron_network_plugin.NeutronNetworkPlugin')

        is_expected.to contain_manila_config('neutronnet/neutron_physical_net_name')\
          .with_value('br-ex')
        is_expected.to contain_manila_config('neutronnet/network_plugin_ipv4_enabled')\
          .with_value(true)
        is_expected.to contain_manila_config('neutronnet/network_plugin_ipv6_enabled')\
          .with_value(false)
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'manila::network::neutron_network'
    end
  end
end
