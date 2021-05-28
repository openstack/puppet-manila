require 'spec_helper'

describe 'manila::backend::dellemc_vmax' do

  let(:title) {'dellemc_vmax'}

  let :required_params do
    {
      :emc_nas_login     => 'admin',
      :emc_nas_password  => 'password',
      :emc_nas_server    => '127.0.0.2',
      :emc_share_backend => 'vmax',
    }
  end

  let :default_params do
    {
      :vmax_server_container  => '<SERVICE DEFAULT>',
      :vmax_share_data_pools  => '<SERVICE DEFAULT>',
      :vmax_ethernet_ports    => '<SERVICE DEFAULT>',
    }
  end

  shared_examples_for 'dell emc vmax share driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures dell emc vmax share driver' do
      is_expected.to contain_manila_config("dellemc_vmax/share_driver").with_value(
        'manila.share.drivers.dell_emc.driver.EMCShareDriver')
      is_expected.to contain_manila_config("dellemc_vmax/driver_handles_share_servers").with_value(true)
      params_hash.each_pair do |config,value|
        is_expected.to contain_manila_config("dellemc_vmax/#{config}").with_value( value )
      end
    end

    it 'marks emc_nas_password as secret' do
      is_expected.to contain_manila_config("dellemc_vmax/emc_nas_password").with_secret( true )
    end
  end

  shared_examples 'manila::backend::dellemc_vmax' do
    context 'with default parameters' do
      let :params do
        required_params
      end

      it_configures 'dell emc vmax share driver'
    end

    context 'with provided parameters' do
      let :params do
        required_params.merge!({
          :vmax_server_container => 'container1',
          :vmax_share_data_pools => '*',
          :vmax_ethernet_ports   => 'eth1',
        })
      end

      it_configures 'dell emc vmax share driver'
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'manila::backend::dellemc_vmax'
    end
  end
end
