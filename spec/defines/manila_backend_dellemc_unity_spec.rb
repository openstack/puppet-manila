require 'spec_helper'

describe 'manila::backend::dellemc_unity' do

  let(:title) {'dellemc_unity'}

  let :required_params do
    {
      :driver_handles_share_servers => true,
      :emc_nas_login                => 'admin',
      :emc_nas_password             => 'password',
      :emc_nas_server               => '127.0.0.2',
      :unity_server_meta_pool       => 'pool1',
    }
  end

  let :default_params do
    {
      :emc_share_backend                       => 'unity',
      :unity_share_data_pools                  => '<SERVICE DEFAULT>',
      :unity_ethernet_ports                    => '<SERVICE DEFAULT>',
      :unity_share_server                      => '<SERVICE DEFAULT>',
      :report_default_filter_function          => '<SERVICE DEFAULT>',
      :network_plugin_ipv6_enabled             => true,
      :emc_ssl_cert_verify                     => '<SERVICE DEFAULT>',
      :emc_ssl_cert_path                       => '<SERVICE DEFAULT>',
      :backend_availability_zone               => '<SERVICE DEFAULT>',
      :reserved_share_percentage               => '<SERVICE DEFAULT>',
      :reserved_share_from_snapshot_percentage => '<SERVICE DEFAULT>',
      :reserved_share_extend_percentage        => '<SERVICE DEFAULT>',
      :max_over_subscription_ratio             => '<SERVICE DEFAULT>',
    }
  end

  shared_examples_for 'dell emc unity share driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures dell emc unity share driver' do
      is_expected.to contain_manila_config("dellemc_unity/share_driver").with_value(
        'manila.share.drivers.dell_emc.driver.EMCShareDriver')
      params_hash.each_pair do |config,value|
        is_expected.to contain_manila_config("dellemc_unity/#{config}").with_value( value )
      end
    end

    it 'marks emc_nas_password as secret' do
      is_expected.to contain_manila_config("dellemc_unity/emc_nas_password").with_secret( true )
    end

    it 'installs storops library' do
      is_expected.to contain_package('storops').with(
        :ensure   => 'installed',
        :provider => 'pip',
        :tag      => 'manila-support-package',
      )
    end
  end

  shared_examples 'manila::backend::dellemc_unity' do
    context 'with default parameters' do
      let :params do
        required_params
      end

      it_configures 'dell emc unity share driver'
    end

    context 'with provided parameters' do
      let :params do
        required_params.merge({
          :unity_share_data_pools                  => '*',
          :unity_ethernet_ports                    => 'eth1',
          :unity_share_server                      => '192.168.0.1',
          :report_default_filter_function          => false,
          :network_plugin_ipv6_enabled             => true,
          :emc_ssl_cert_verify                     => true,
          :emc_ssl_cert_path                       => '/etc/ssl/certs/',
          :backend_availability_zone               => 'my_zone',
          :reserved_share_percentage               => 10.0,
          :reserved_share_from_snapshot_percentage => 10.1,
          :reserved_share_extend_percentage        => 10.2,
          :max_over_subscription_ratio             => 1.5,
        })
      end

      it_configures 'dell emc unity share driver'
    end

    context 'with share server config' do
      let :params do
        required_params.merge({
          :emc_nas_password => true,
        })
      end

     it { is_expected.to raise_error(Puppet::Error) }
    end

    context 'with storops library unmanaged' do
      let :params do
        required_params.merge({
          :manage_storops => false
        })
      end

      it { is_expected.to_not contain_package('storops') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'manila::backend::dellemc_unity'
    end
  end
end
