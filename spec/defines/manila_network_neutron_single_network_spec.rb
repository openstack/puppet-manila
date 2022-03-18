require 'spec_helper'

describe 'manila::network::neutron_single_network' do
  let("title") {'neutronsingle'}

  let :params do
    {
      :neutron_net_id    => 'e378d6e6-7d6c-4e59-86cc-067043145377',
      :neutron_subnet_id => 'a0a8c559-09ad-4112-abc6-473137117880',
    }
  end

  shared_examples 'manila::network::neutron_single_network' do
    context 'with required parameters' do
      it 'configures neutron single network plugin' do
        is_expected.to contain_manila_config("neutronsingle/network_api_class").with_value(
          'manila.network.neutron.neutron_network_plugin.NeutronSingleNetworkPlugin')

        is_expected.to contain_manila_config('neutronsingle/neutron_net_id')\
          .with_value('e378d6e6-7d6c-4e59-86cc-067043145377')
        is_expected.to contain_manila_config('neutronsingle/neutron_subnet_id')\
          .with_value('a0a8c559-09ad-4112-abc6-473137117880')
        is_expected.to contain_manila_config('neutronsingle/network_plugin_ipv4_enabled')\
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('neutronsingle/network_plugin_ipv6_enabled')\
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
        is_expected.to contain_manila_config("neutronsingle/network_api_class").with_value(
          'manila.network.neutron.neutron_network_plugin.NeutronSingleNetworkPlugin')

        is_expected.to contain_manila_config('neutronsingle/neutron_net_id')\
          .with_value('e378d6e6-7d6c-4e59-86cc-067043145377')
        is_expected.to contain_manila_config('neutronsingle/neutron_subnet_id')\
          .with_value('a0a8c559-09ad-4112-abc6-473137117880')
        is_expected.to contain_manila_config('neutronsingle/network_plugin_ipv4_enabled')\
          .with_value(true)
        is_expected.to contain_manila_config('neutronsingle/network_plugin_ipv6_enabled')\
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

      it_behaves_like 'manila::network::neutron_single_network'
    end
  end
end
