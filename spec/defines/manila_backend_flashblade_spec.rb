require 'spec_helper'

describe 'manila::backend::flashblade' do

  let(:title) {'flashblade'}

  let :required_params do
    {
      :flashblade_api      => 'admin',
      :flashblade_mgmt_vip => '10.1.1.1',
      :flashblade_data_vip => '10.1.1.2',
    }
  end

  let :default_params do
    {
      :flashblade_eradicate                    => true,
      :backend_availability_zone               => '<SERVICE DEFAULT>',
      :reserved_share_percentage               => '<SERVICE DEFAULT>',
      :reserved_share_from_snapshot_percentage => '<SERVICE DEFAULT>',
      :reserved_share_extend_percentage        => '<SERVICE DEFAULT>',
      :max_over_subscription_ratio             => '<SERVICE DEFAULT>',
    }
  end

  shared_examples_for 'pure storage flashblade share driver' do
    let :params_hash do
      default_params.merge(required_params)
    end

    it 'configures pure storage flashblade share driver' do
      is_expected.to contain_manila_config("flashblade/share_driver").with_value(
	      'manila.share.drivers.purestorage.flashblade.FlashBladeShareDriver')
      is_expected.to contain_manila_config("flashblade/driver_handles_share_servers").with_value ( false )
      params_hash.each_pair do |config,value|
        is_expected.to contain_manila_config("flashblade/#{config}").with_value( value )
      end
    end

    it 'marks flashblade_api as secret' do
      is_expected.to contain_manila_config("flashblade/flashblade_api").with_secret( true )
    end
  end

  shared_examples 'manila::backend::flashblade' do
    context 'with provided parameters' do
      let :params do
        required_params
      end

      it_configures 'pure storage flashblade share driver'
    end

    context 'with share server config' do
      let :params do
        required_params.merge!({
          :flashblade_eradicate                    => true,
          :backend_availability_zone               => 'my_zone',
          :reserved_share_percentage               => 10.0,
          :reserved_share_from_snapshot_percentage => 10.1,
          :reserved_share_extend_percentage        => 10.2,
          :max_over_subscription_ratio             => 1.5,
        })
      end

      it_configures "pure storage flashblade share driver"
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'manila::backend::flashblade'
    end
  end
end
