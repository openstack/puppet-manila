require 'spec_helper'

describe 'manila::backend::dellemc_vnx' do

  let(:title) {'dellemc_vnx'}

  let :required_params do
    {
      :emc_nas_login               => 'admin',
      :emc_nas_password            => 'password',
      :emc_nas_server              => '127.0.0.2',
      :emc_share_backend           => 'vnx',
    }
  end

  let :default_params do
    {
      :vnx_server_container         => '<SERVICE DEFAULT>',
      :vnx_share_data_pools         => '<SERVICE DEFAULT>',
      :vnx_ethernet_ports           => '<SERVICE DEFAULT>',
      :network_plugin_ipv6_enabled  => true,
      :emc_ssl_cert_verify          => false,
      :emc_ssl_cert_path            => '<SERVICE DEFAULT>',
      :backend_availability_zone    => '<SERVICE DEFAULT>',
    }
  end

  shared_examples_for 'dell emc vnx share driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures dell emc vnx share driver' do
      is_expected.to contain_manila_config("dellemc_vnx/share_driver").with_value(
        'manila.share.drivers.dell_emc.driver.EMCShareDriver')
      is_expected.to contain_manila_config("dellemc_vnx/driver_handles_share_servers").with_value(true)
      params_hash.each_pair do |config,value|
        is_expected.to contain_manila_config("dellemc_vnx/#{config}").with_value( value )
      end
    end

    it 'marks emc_nas_password as secret' do
      is_expected.to contain_manila_config("dellemc_vnx/emc_nas_password").with_secret( true )
    end
  end

  shared_examples 'manila::backend::dellemc_vnx' do
    context 'with default parameters' do
      let :params do
        required_params
      end

      it_configures 'dell emc vnx share driver'
    end

    context 'with provided parameters' do
      let :params do
        required_params.merge({
          :vnx_server_container        => 'container1',
          :vnx_share_data_pools        => '*',
          :vnx_ethernet_ports          => 'eth1',
          :network_plugin_ipv6_enabled => true,
          :emc_ssl_cert_verify         => true,
          :emc_ssl_cert_path           => '/etc/ssl/certs/',
          :backend_availability_zone   => 'my_zone',
        })
      end

      it_configures 'dell emc vnx share driver'
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'manila::backend::dellemc_vnx'
    end
  end
end
