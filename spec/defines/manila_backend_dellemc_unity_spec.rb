require 'spec_helper'

describe 'manila::backend::dellemc_unity' do

  let(:title) {'dellemc_unity'}

  let :params do
    {
      :driver_handles_share_servers         => true,
      :emc_nas_login                        => 'admin',
      :emc_nas_password                     => 'password',
      :emc_nas_server                       => '127.0.0.2',
      :emc_share_backend                    => 'unity',
      :unity_server_meta_pool               => 'pool1',
      :unity_share_data_pools               => '*',
      :unity_ethernet_ports                 => 'eth1',
      :network_plugin_ipv6_enabled          => true,
      :emc_ssl_cert_verify                  => true,
      :emc_ssl_cert_path                    => '/etc/ssl/certs/',
    }
  end

  let :default_params do
    {
      :unity_server_meta_pool       => '<SERVICE DEFAULT>',
      :unity_share_data_pools       => '<SERVICE DEFAULT>',
      :unity_ethernet_ports         => '<SERVICE DEFAULT>',
      :network_plugin_ipv6_enabled  => '<SERVICE DEFAULT>',
      :emc_ssl_cert_verify          => '<SERVICE DEFAULT>',
      :emc_ssl_cert_path            => '<SERVICE DEFAULT>',
    }
  end

  shared_examples_for 'dell emc unity share driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures dell emc unity share driver' do
      is_expected.to contain_manila_config("dellemc_unity/share_driver").with_value(
        'manila.share.drivers.emc.driver.EMCShareDriver')
      params_hash.each_pair do |config,value|
        is_expected.to contain_manila_config("dellemc_unity/#{config}").with_value( value )
      end
    end

    it 'marks emc_nas_password as secret' do
      is_expected.to contain_manila_config("dellemc_unity/emc_nas_password").with_secret( true )
    end
  end


  context 'with default parameters' do
    before do
      params = {}
    end

    it_configures 'dell emc unity share driver'
  end

  context 'with provided parameters' do
    it_configures 'dell emc unity share driver'
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
