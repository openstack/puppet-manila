require 'spec_helper'

describe 'manila::network::neutron_single_network' do
  let("title") {'neutronsingle'}

  let :params do
    {
      :neutron_net_id              => 'abcdef',
      :neutron_subnet_id           => 'ghijkl',
      :network_plugin_ipv4_enabled => '<SERVICE DEFAULT>',
      :network_plugin_ipv6_enabled => '<SERVICE DEFAULT>',
    }
  end

  shared_examples 'manila::network::neutron_single_network' do
    context 'with provided parameters' do
      it 'configures neutron single network plugin' do
        is_expected.to contain_manila_config("neutronsingle/network_api_class").with_value(
          'manila.network.neutron.neutron_network_plugin.NeutronSingleNetworkPlugin')

        params.each_pair do |config,value|
          is_expected.to contain_manila_config("neutronsingle/#{config}").with_value( value )
        end
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

      it_behaves_like 'manila::network::neutron_single_network'
    end
  end
end
