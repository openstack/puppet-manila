require 'spec_helper'

describe 'manila::backend::dellemc_isilon' do

  let(:title) {'dellemc_isilon'}

  let :required_params do
    {
      :emc_nas_login     => 'admin',
      :emc_nas_password  => 'password',
      :emc_nas_server    => '127.0.0.2',
      :emc_share_backend => 'isilon',
    }
  end

  let :default_params do
    {
      :emc_nas_root_dir      => '<SERVICE DEFAULT>',
      :emc_nas_server_port   => 8080,
      :emc_nas_server_secure => true,
    }
  end

  shared_examples_for 'dell emc isilon share driver' do
    let :params_hash do
      default_params.merge(params)
    end

    it 'configures dell emc isilon share driver' do
      is_expected.to contain_manila_config("dellemc_isilon/share_driver").with_value(
        'manila.share.drivers.dell_emc.driver.EMCShareDriver')
      is_expected.to contain_manila_config("dellemc_isilon/driver_handles_share_servers").with_value(false)
      params_hash.each_pair do |config,value|
        is_expected.to contain_manila_config("dellemc_isilon/#{config}").with_value( value )
      end
    end

    it 'marks emc_nas_password as secret' do
      is_expected.to contain_manila_config("dellemc_isilon/emc_nas_password").with_secret( true )
    end
  end

  shared_examples 'manila::backend::dellemc_isilon' do
    context 'with default parameters' do
      let :params do
        required_params
      end

      it_configures 'dell emc isilon share driver'
    end

    context 'with provided parameters' do
      let :params do
        required_params.merge!({
          :emc_nas_root_dir      => 'myroot',
          :emc_nas_server_port   => 8000,
          :emc_nas_server_secure => false,
        })
      end

      it_configures 'dell emc isilon share driver'
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'manila::backend::dellemc_isilon'
    end
  end
end
