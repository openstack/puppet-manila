require 'spec_helper'

describe 'manila::backend::dellemc_vnx' do

  let(:title) {'dellemc_vnx'}

  let :params do
    {
      :driver_handles_share_servers  => true,
      :emc_nas_login                 => 'admin',
      :emc_nas_password              => 'password',
      :emc_nas_server                => '127.0.0.2',
      :emc_share_backend             => 'vnx',
      :vnx_server_container          => 'container1',
      :vnx_share_data_pools          => '*',
      :vnx_ethernet_ports            => 'eth1',
      :network_plugin_ipv6_enabled   => true,
      :emc_ssl_cert_verify           => true,
      :emc_ssl_cert_path             => '/etc/ssl/certs/',
    }
  end

  let :default_params do
    {
      :vnx_server_container         => '<SERVICE DEFAULT>',
      :vnx_share_data_pools         => '<SERVICE DEFAULT>',
      :vnx_ethernet_ports           => '<SERVICE DEFAULT>',
      :network_plugin_ipv6_enabled  => '<SERVICE DEFAULT>',
      :emc_ssl_cert_verify          => '<SERVICE DEFAULT>',
      :emc_ssl_cert_path            => '<SERVICE DEFAULT>',
    }
  end

  shared_examples_for 'dell emc vnx share driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures dell emc vnx share driver' do
      is_expected.to contain_manila_config("dellemc_vnx/share_driver").with_value(
        'manila.share.drivers.dell_emc.driver.EMCShareDriver')
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
      before do
        params = {}
      end

      it_configures 'dell emc vnx share driver'
    end

    context 'with provided parameters' do
      it_configures 'dell emc vnx share driver'
    end

    context 'with share server config' do
      before do
        params.merge!({
          :emc_nas_password => true,
        })
      end

      it { is_expected.to raise_error(Puppet::Error, /true is not a string.  It looks to be a TrueClass/) }
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
