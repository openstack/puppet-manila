require 'spec_helper'

describe 'manila::backend::dellemc_powermax' do

  let(:title) {'dellemc_powermax'}

  let :required_params do
    {
      :emc_nas_login     => 'admin',
      :emc_nas_password  => 'password',
      :emc_nas_server    => '127.0.0.2',
    }
  end

  let :default_params do
    {
      :emc_share_backend                       => 'powermax',
      :powermax_server_container               => '<SERVICE DEFAULT>',
      :powermax_share_data_pools               => '<SERVICE DEFAULT>',
      :powermax_ethernet_ports                 => '<SERVICE DEFAULT>',
      :backend_availability_zone               => '<SERVICE DEFAULT>',
      :reserved_share_percentage               => '<SERVICE DEFAULT>',
      :reserved_share_from_snapshot_percentage => '<SERVICE DEFAULT>',
      :reserved_share_extend_percentage        => '<SERVICE DEFAULT>',
    }
  end

  shared_examples_for 'dell emc powermax share driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures dell emc powermax share driver' do
      is_expected.to contain_manila_config("dellemc_powermax/share_driver").with_value(
        'manila.share.drivers.dell_emc.driver.EMCShareDriver')
      is_expected.to contain_manila_config("dellemc_powermax/driver_handles_share_servers").with_value(true)
      params_hash.each_pair do |config,value|
        is_expected.to contain_manila_config("dellemc_powermax/#{config}").with_value( value )
      end
    end

    it 'marks emc_nas_password as secret' do
      is_expected.to contain_manila_config("dellemc_powermax/emc_nas_password").with_secret( true )
    end
  end

  shared_examples 'manila::backend::dellemc_powermax' do
    context 'with default parameters' do
      let :params do
        required_params
      end

      it_configures 'dell emc powermax share driver'
    end

    context 'with provided parameters' do
      let :params do
        required_params.merge!({
          :powermax_server_container               => 'container1',
          :powermax_share_data_pools               => '*',
          :powermax_ethernet_ports                 => 'eth1',
          :backend_availability_zone               => 'my_zone',
          :reserved_share_percentage               => 10.0,
          :reserved_share_from_snapshot_percentage => 10.1,
          :reserved_share_extend_percentage        => 10.2,
        })
      end

      it_configures 'dell emc powermax share driver'
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'manila::backend::dellemc_powermax'
    end
  end
end
