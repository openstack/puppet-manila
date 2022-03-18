require 'spec_helper'

describe 'manila::network::standalone' do
  let("title") {'standalone'}

  let :params do
    {
      :standalone_network_plugin_gateway => '192.168.1.1',
      :standalone_network_plugin_mask    => '255.255.255.0',
    }
  end

  shared_examples 'manila::network::standalone' do
    context 'with required parameters' do
      it 'configures standalone network plugin' do
        is_expected.to contain_manila_config("standalone/network_api_class").with_value(
          'manila.network.standalone_network_plugin.StandaloneNetworkPlugin')

        is_expected.to contain_manila_config('standalone/standalone_network_plugin_gateway')\
          .with_value('192.168.1.1')
        is_expected.to contain_manila_config('standalone/standalone_network_plugin_mask')\
          .with_value('255.255.255.0')
        is_expected.to contain_manila_config('standalone/standalone_network_plugin_segmentation_id')\
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('standalone/standalone_network_plugin_allowed_ip_ranges')\
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('standalone/network_plugin_ipv4_enabled')\
          .with_value('<SERVICE DEFAULT>')
        is_expected.to contain_manila_config('standalone/network_plugin_ipv6_enabled')\
          .with_value('<SERVICE DEFAULT>')
      end
    end

    context 'with custom parameters' do
      before do
        params.merge!({
          :standalone_network_plugin_segmentation_id   => '1001',
          :standalone_network_plugin_allowed_ip_ranges => '10.0.0.10-10.0.0.20',
          :network_plugin_ipv4_enabled                 => true,
          :network_plugin_ipv6_enabled                 => false,
        })
      end

      it 'configures standalone network plugin' do
        is_expected.to contain_manila_config('standalone/standalone_network_plugin_segmentation_id')\
          .with_value('1001')
        is_expected.to contain_manila_config('standalone/standalone_network_plugin_allowed_ip_ranges')\
          .with_value('10.0.0.10-10.0.0.20')
        is_expected.to contain_manila_config('standalone/network_plugin_ipv4_enabled')\
          .with_value(true)
        is_expected.to contain_manila_config('standalone/network_plugin_ipv6_enabled')\
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

      it_behaves_like 'manila::network::standalone'
    end
  end
end
