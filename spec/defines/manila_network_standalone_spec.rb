require 'spec_helper'

describe 'manila::network::standalone' do
  let("title") {'standalone'}

  let :params do
    {
      :standalone_network_plugin_gateway            => '192.168.1.1',
      :standalone_network_plugin_mask               => '255.255.255.0',
      :standalone_network_plugin_segmentation_id    => '1001',
      :standalone_network_plugin_allowed_ip_ranges  => '10.0.0.10-10.0.0.20',
    }
  end


  shared_examples_for 'standalone network plugin' do

    it 'configures standalone network plugin' do

      is_expected.to contain_manila_config("standalone/network_api_class").with_value(
        'manila.network.standalone_network_plugin.StandaloneNetworkPlugin')

      params.each_pair do |config,value|
        is_expected.to contain_manila_config("standalone/#{config}").with_value( value )
      end
    end
  end

  shared_examples 'manila::network::standalone' do
    context 'with default parameters' do
      before do
        params = {}
      end

      it_configures 'standalone network plugin'
    end

    context 'with provided parameters' do
      it_configures 'standalone network plugin'
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
